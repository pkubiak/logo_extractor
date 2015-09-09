require 'spec_helper'

describe 'FaviconHandler' do
  describe '#extract' do
    cases = {
      # website which doesnt contain implicit logo in content
      'http://www.8lo.pl/' => [[51, "http://8lo.pl/wp-content/themes/8LO/img/pik.png"]],
      'http://stackoverflow.com/' => [[52, "md5:91b81bc58566fe0127141c2841073508"], [36, "md5:3367cc1cc34240398ff0638e2aa2d4a4"], [171, "http://cdn.sstatic.net/stackoverflow/img/favicon.ico?v=6cd6089ee7f6"]]
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
