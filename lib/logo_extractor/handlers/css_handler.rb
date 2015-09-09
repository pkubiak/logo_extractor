require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'css_parser'

#TODO: handle relative paths
#TODO: remove img which aren't logo (dont score only for visibility)


# Simply extractor which try to find logo in img tag
# return array of uri
module LogoExtractor
  module Handlers
    class CssHandler

      LogoExtractor.register_handler 'css' do |url|
        keywords = {
          'logo'=> 50,
          'header'=> 10,
          'logos'=> -25,
          'bip'=> -50,
        }

        doc = Nokogiri::HTML(open(url, :allow_redirections => :all))
        base_uri = URI(url)

        background = /url\(["']?(.+?)["']?\)/
        results = []

        # after http://www.w3schools.com/css/css_pseudo_classes.asp
        #TODO: add nth-child, etc
        permited_css = ['::after', ':after', '::before', ':before', ':hover', ':active', ':link', ':visited',
                        ':checked', ':disabled', ':empty', ':enabled', ':first-child', ':first-of-type', ':focus',
                        ':invalid', ':last-child' ':last-of-type', ':only-of-type', ':optional', ':out-of-range',
                        ':read-only', ':read-write', ':required', ':root', ':target', ':valid', ':visited',
                        '::first-letter', ':first-letter', '::first-line', ':first-line', '::selection', ':selection']

        ruler = Proc.new do |rule_set, uri|
          rule_set.each_declaration do |property, value|
            if ['background', 'background-image'].include? property.downcase then
              background_url = background.match(value)

              if background_url then
                score = 0

                score += 60 if rule_set.selectors.any?{ |sel| sel.downcase.include? 'logo' }

                # check if background path contains 'logo'
                keywords.each do |k,v|
                  score += v if background_url[1].downcase.include? k
                end

                # check if given property match any element in document
                score += 50 if rule_set.selectors.any? do |sel|
                  permited_css.each{|x| sel = sel.gsub(x, '')}
                  doc.css(sel).length > 0
                end

                results.push([score, URI.join(uri, URI.escape(background_url[1])).to_s])
              end
            end
          end
        end

        # Extract rules from linked stylesheeds
        doc.css('link[rel=stylesheet]').each do |link|
          if link.attr('href') then
            parser = CssParser::Parser.new

            uri = URI.join(url, link.attr('href'))

            parser.load_uri! uri

            parser.each_rule_set do |rule_set|
              ruler.call(rule_set, uri)
            end
          end
        end


        # Extract embeded stylesheets
        parser = CssParser::Parser.new

        doc.css('style').each do |style|
          parser.add_block! style.text
        end

        parser.each_rule_set do |rule_set|
          ruler.call(rule_set, base_uri)
        end

        # Extract from inline style
        doc.css('*[style]').each do |elem|
          parser = CssParser::Parser.new
          parser.add_block! 'div { ' + elem.attr('style') + '}' # To imitate right block
          parser.each_rule_set do |rule_set|
            rule_set.each_declaration do |property, value|
              if ['background', 'background-image'].include? property.downcase then
                background_url = background.match(value)

                if background_url then
                  score = 50 # For existing element
                  score += 60 if [elem.attr('id'), elem.attr('class'), elem.attr('title'), elem.attr('alt')].any?{ |sel| (sel||'').downcase.include? 'logo' }

                  keywords.each do |k,v|
                    score += v if background_url[1].downcase.include? k
                  end

                  score = 0 if score == 50 # Remove elements that doesnt meet any other condition

                  results.push([score, URI.join(base_uri, URI.escape(background_url[1])).to_s])
                end
              end
            end
          end
        end

        # remove 0 scored imgs
        results = results.compact.select{ |x| x[0] > 0 }

        # sort in descending score order
        results.sort_by!{|x| -x[0]}
      end
    end
  end
end
