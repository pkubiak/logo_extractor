require 'spec_helper'

describe 'LogoExtractor' do
  describe '#register_extractor' do
    it 'handler registration works' do
      test_url = 'http://www.google.com'
      
      LogoExtractor.register_handler 'copy' do |url|
        [url]
      end
      
      expect(LogoExtractor.extract(test_url,'copy')).to eq [test_url]
    end
    
    it 'html_handler should be registrated' do
      expect(LogoExtractor.handlers).to include('html-img')    
    end
  end
end