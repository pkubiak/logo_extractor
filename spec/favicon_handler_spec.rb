require 'spec_helper'

describe 'FaviconHandler' do
  describe '#extract' do
    cases = {
      # website which doesnt contain implicit logo in content
      'http://www.8lo.pl/' => [[51, "http://8lo.pl/wp-content/themes/8LO/img/pik.png"]],
      'http://mnslab.pl/' => [[36,'http://mnslab.pl/img/favicon.ico']],

      #TODO: Need remove metadata to compare results for data-uri
      #'http://stackoverflow.com/' => [[171, "http://cdn.sstatic.net/stackoverflow/img/favicon.ico?v=6cd6089ee7f6"], [52, "md5:5918a91fd44788de4dadb6d96958e9d0"], [36, "md5:612ad5e42370292838b834028579d066"]]
      # favicon.ico contains multiple icons, Imagemagick is able to convert them into pngs
      # 'http://fortawesome.github.io/' => [],

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
