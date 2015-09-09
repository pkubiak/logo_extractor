require 'spec_helper'

describe 'CssHandler' do
  describe '#extract' do
    cases = {
      # simple tests
      #'http://stackoverflow.com/' => [[30, #"http://cdn.sstatic.net/stackoverflow/img/logo-10m.svg?v=fc0904eba1b1"], [10, #"http://cdn.sstatic.net/stackoverflow/img/sprites.svg?v=1bc768be1b3c"]],

      # google require support for inline styles
      'http://www.google.com/' => [[160, "http://www.google.com/images/branding/googlelogo/1x/googlelogo_white_background_color_272x92dp.png"], [100, "http://www.google.com/images/srpr/nav_logo80.png"]],

      'http://mnslab.pl/' => [[100, "http://mnslab.pl/img/logo_smaller.png"], [60, "http://mnslab.pl/img/header-bg.jpg"]]
    }


    cases.each do |k,v|
      it "extract logo url from: #{k}" do
        expect(LogoExtractor.extract_all(k, 'css')).to eq v
      end
    end
  end
end
