require 'spec_helper'

describe 'LogoExtractor' do
  describe '#register_extractor' do
    it 'handler registration works' do
      test_url = 'http://www.google.com'
      
      LogoExtractor.register_handler 'copy' do |url|
        [[0, url]]
      end
      
      expect(LogoExtractor.extract_all(test_url,'copy')).to eq [[0, test_url]]
    end
    
    it 'html_handler should be registrated' do
      expect(LogoExtractor.handlers).to include('html-img')    
    end
  end
  
  describe '#extract_url' do
    cases = {
      'http://mnsprzetargi.pl/' => 'http://mnsprzetargi.pl/logo.png',
      'https://www.python.org/' => 'https://www.python.org/static/img/python-logo.png',
      'http://www.viessmann.pl/' => 'http://www.viessmann.pl/content/dam/internet-global/images/general/7590.gif',
      'http://facebook.com/' => nil, #url cant by extracted
      'https://www.google.com/' => 'https://www.google.pl/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
      'http://stackoverflow.com/' => 'http://cdn.sstatic.net/stackoverflow/img/logo-10m.svg?v=fc0904eba1b1',
      #'http://www.github.com/' => '', #logo as font glyph
      'http://www.uj.edu.pl/' => 'http://www.uj.edu.pl/uj-lift-theme/images/logotypes/uj-pl.svg',
    }
    
    cases.each do |k,v|
      it "extract logo url from: #{k}" do
        expect(LogoExtractor.extract(k)).to eq v
      end
    end
  end
end