require 'spec_helper'

describe 'HtmlHandler' do
  describe '#extract_all' do
    it 'extract logos using html handler' do
      cases = {
        # simple tests
        'https://www.python.org/' => [[191, 'https://www.python.org/static/img/python-logo.png']],
        'http://mnsprzetargi.pl/' => [[226, 'http://mnsprzetargi.pl/logo.png']],
        'http://www.onet.pl/' => [[176, "http://ocdn.eu/images/pulscms/NDM7MDA_/b5c5fb9cdc2e52baabb3b537ab25ad67.png"], [76, "http://ocdn.eu/images/pulscms/ZDk7MDYsNGIsMWE_/439416ced0031662550f922ff0d8c8e5.png"]],
        'https://www.linkedin.com/company/mns-lab-sp-z-o-o-' => [[76, "https://media.licdn.com/mpr/mpr/shrink_200_200/AAEAAQAAAAAAAAboAAAAJGM4Zjg2YmExLTVkYzQtNDBjMy04MzJjLTEwMTkyNzQ5ZDllMg.png"], [41, "https://static.licdn.com/scds/common/u/img/themes/katy/ghosts/companies/ghost_company_60x60_v1.png"]],
        'http://www.viessmann.pl/' => [[70, "http://www.viessmann.pl/content/dam/internet-global/images/general/7590.gif"]],
        # 0 scored img should be removed
        'http://www.tutorialspoint.com/ruby/ruby_modules.htm' => [[226, "http://www.tutorialspoint.com/ruby/images/logo.png"], [226, "http://www.tutorialspoint.com/scripts/img/logo-footer.png"], [120, "http://www.tutorialspoint.com/ruby/images/ruby-mini-logo.jpg"]],        

        # need test with base
      }
    
      cases.each do |k,v|
        expect(LogoExtractor.extract_all(k, 'html-img')).to eq v      
      end
    end
  end
end