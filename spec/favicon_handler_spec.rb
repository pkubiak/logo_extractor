require 'spec_helper'

describe 'FaviconHandler' do
  describe '#extract' do
    cases = {
      # website which doesnt contain implicit logo in content
      'http://www.8lo.pl/' => [[51, "http://8lo.pl/wp-content/themes/8LO/img/pik.png"]],
      'http://mnslab.pl/' => [[36,'http://mnslab.pl/img/favicon.ico']],

      #TODO: Need remove metadata to compare results for data-uri
      'http://stackoverflow.com/' => [[171, "http://cdn.sstatic.net/stackoverflow/img/favicon.ico?v=6cd6089ee7f6"], [52, "md5:d9232ee1ff2f6cdc584f6e6f5412eaaa"], [36, "md5:4ccebdbe8aebd8f2f98451c2907dd5e3"]],

      # favicon.ico contains multiple icons, Imagemagick is able to convert them into pngs
      'http://fortawesome.github.io/Font-Awesome/' => [[276, "md5:f48dc08d9c12c3635e085846c25de7bb"], [68, "md5:86219c6975247636c184a91349ebb4ff"], [52, "md5:60dd202112a31ad205abcf93f33ff929"], [36, "md5:8bcc2660b8ca04cd8cb7a9503eef2877"]],

      # Handling cookies test
      #'http://www.uj.edu.pl/' => [],
    }

    expect_cases cases do |url|
      LogoExtractor.extract_all(url, 'favicon')
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
