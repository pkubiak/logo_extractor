require 'spec_helper'

describe 'CssHandler' do
  describe '#extract' do
    it 'extract logos using css handler' do
      cases = {
        # simple tests
        'http://stackoverflow.com/' => [[30, "http://cdn.sstatic.net/stackoverflow/img/logo-10m.svg?v=fc0904eba1b1"], [10, "http://cdn.sstatic.net/stackoverflow/img/sprites.svg?v=1bc768be1b3c"]],
        'http://www.google.com/' => [],
        
        # need test with base
      }
    
      cases.each do |k,v|
        expect(LogoExtractor.extract(k, 'css')).to eq v      
      end
    end
  
  end
end