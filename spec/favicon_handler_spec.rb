require 'spec_helper'

describe 'FaviconHandler' do
  describe '#extract' do
    it 'logos using favicon handler' do
      cases = {
        # website which doesnt contain implicit logo in content
        'http://www.8lo.pl/' => [[20, "http://8lo.pl/wp-content/themes/8LO/img/pik.png"]],
        
        # favicon.ico contains multiple icons, Imagemagick is able to convert them into pngs
        # 'http://fortawesome.github.io/' => [],
        
        # Handling cookies test
        #'http://www.uj.edu.pl/' => [],
      }
    
      cases.each do |k,v|
        expect(LogoExtractor.extract(k, 'favicon')).to eq v      
      end
    end
  
  end
end