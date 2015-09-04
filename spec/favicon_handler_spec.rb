require 'spec_helper'

describe 'FaviconHandler' do
  describe '#extract' do
    it 'logos using favicon handler' do
      cases = {
        # website which doesnt contain implicit logo in content
        'http://www.8lo.pl/' => [[51, "http://8lo.pl/wp-content/themes/8LO/img/pik.png"]],
        'http://stackoverflow.com/' => [],
        # favicon.ico contains multiple icons, Imagemagick is able to convert them into pngs
        # 'http://fortawesome.github.io/' => [],
        
        # Handling cookies test
        #'http://www.uj.edu.pl/' => [],
      }
    
      cases.each do |k,v|
        expect(LogoExtractor.extract_all(k, 'favicon')).to eq v      
      end
    end
  end
  
  describe '#extract_ico_file' do
    it 'should extract multiple pngs' do
      url = 'http://fortawesome.github.io/Font-Awesome/assets/ico/favicon.ico'
      icons = LogoExtractor::Handlers::FaviconHandler.extract_ico_layers(url)
      
      expect(icons.length).to eq 4
    end
  
    it 'should return original url in case there is only one layer' do
      url = 'http://rozklad-pkp.pl/favicon.ico'
      icons = LogoExtractor::Handlers::FaviconHandler.extract_ico_layers(url)
      
      expect(icons[0][0]).to eq url
    end
    
  end
end