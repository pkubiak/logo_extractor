require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

# Simply extractor which try to find logo in img tag
# return array of uri
module LogoExtractor
  module Handlers
    class HtmlHandler
      CRITERIONS = LogoExtractor::FORMAT_CRITERIONS + LogoExtractor::KEYWORDS_CRITERIONS + [:keyword_in_anncestor, :parents_anchor]
      
      LogoExtractor.register_handler 'html-img', CRITERIONS do |url|
        doc = Nokogiri::HTML(open(url, :allow_redirections => :all))

        #determine base url
        base = url
        doc.css('base').each do |url|
          base = url.attr('href') || base
        end

        attr_weight = {
          :class => :keyword_in_class,
          :src => :keyword_in_src,
          :id => :keyword_in_id,
          :title => :keyword_in_title,
          :alt => :keyword_in_alt,
        }

        ext_weight = {
          '.svg' => :is_svg,
          '.png' => :is_png,
          '.jpg' => :is_jpg,
          '.gif' => :is_gif,
          '.jpeg' => :is_jpg,
          '.bmp' => :is_bmp,
        }

        keywords = LogoExtractor::KEYWORDS


        imgs = doc.css('img').map do |img|
          #score = 0
          criterions = {}

          src = img.attr('src')
          next nil unless src

          # make img url global
          src = URI.join(base, URI.escape(src)).to_s


          # find keyword in img attributes and compute total score of this img
          attr_weight.each do |attrib, weight|
            keywords.each do |keyword, value|
              if img.attr(attrib) and img.attr(attrib).downcase.include? keyword.downcase then
                #attr_score += weight*value
                #TODO: Should we sum scores for multiple keywords or max them?
                criterions[weight] = [criterions[weight] || 0, value].max 
              end
            end
          end
          
          # scoring based on parent a href
          if img.parent.name == 'a' and img.parent.attr('href') then
            #puts img.parent.attr('href')
            href = URI(img.parent.attr('href'))
            if ['', '/', 'index.php', 'index.html', 'index.htm', 'index.aspx'].include? href.path then
              criterions[:parents_anchor] = 1
            end
          end

          # scoring based of anncestor class name&id
          i = img.parent
          while i.name != 'document' do
            keywords.each do |keyword, value|
              if ((i.attr('class') || '')+' '+(i.attr('id') || '')).downcase.include? keyword then
                #class_score = [class_score, value*6/i.css('img').length].max
                criterions[:keyword_in_anncestor] = [criterions[:keyword_in_anncestor]||0, value].max
              end
            end
            i = i.parent
          end

          # test below only run if img has already received some points
          next nil if criterions.empty?

          #scoring based on file type
          ext = File.extname(img.attr('src') || '').downcase
          if ext_weight[ext] then
            criterions[ext_weight[ext]] = 1
          end

          [criterions, src]
        end
      end
    end
  end
end
