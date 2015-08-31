require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

#TODO: scoring based on size
#TODO: add point for how far from begining of document element is
          
# Simply extractor which try to find logo in img tag
# return array of uri
module LogoExtractor
  module Handlers
    class HtmlHandler
      LogoExtractor.register_handler 'html-img' do |url|
        doc = Nokogiri::HTML(open(url, :allow_redirections => :all))
 
        #determine base url
        base = url
        doc.css('base').each do |url|
          base = url.attr('href') || base
        end
               
        # how much each criterion is worth
        weights = {
          :attr => 100,
          :parent => 100,
          :class => 60,
          :size => 20,
          :ext => 20,
        }
        
        attr_weights = {
          :class => 5,
          :src => 10,
          :id => 10,
          :title => 1,
          :alt => 1
        }
        
        ext_weight = {
          '.svg' => 100,
          '.png' => 80,
          '.jpg' => 50,
          '.gif' => 50,
          '.jpeg' => 50,
          '.bmp' => 10,
        }
        
        keywords = {
          'logo' => 10,
          'logos' => -5,
        #  'logotyp' => 4,
        }
        

        imgs = doc.css('img').map do |img|
          score = 0
          
          src = img.attr('src')
          next nil unless src
          
          # make img url global
          src = URI.join(base, URI.escape(src)).to_s
          
          
          # find keyword in img attributes and compute total score of this img
          attr_score = 0
          attr_weights.each do |attrib, weight|
            keywords.each do |keyword, value|
              if img.attr(attrib) and img.attr(attrib).downcase.include? keyword then
                attr_score += weight*value
              end
            end
          end
          score = weights[:attr]*attr_score/200 # use 200 as max value for attr_score

 
          #TODO: blacklisting
          
          # scoring based on parent a href
          if img.parent.name == 'a' and img.parent.attr('href') then
            #puts img.parent.attr('href')
            href = URI(img.parent.attr('href'))
            if ['', '/', 'index.php', 'index.html', 'index.htm', 'index.aspx'].include? href.path then
              score += weights[:parent] 
            end
          end
          
          # scoring based of anncestor class name&id
          i = img.parent
          class_score = 0
          while i.name != 'document' do
            keywords.each do |keyword, value|
              if ((i.attr('class') || '')+' '+(i.attr('id') || '')).downcase.include? keyword then
                class_score = [class_score, value*6/i.css('img').length].max
              end
            end
            i = i.parent
          end
          score += [class_score, weights[:class]].min 
          
          
          # test below only run if img has already received some points   
          next nil if score <= 0
          
          
          #scoring based on file type
          ext = File.extname(img.attr('src') || '').downcase
          if ext_weight[ext] then
            score += weights[:ext]*ext_weight[ext]/100
          end
                 

          [score, src]
        end  
        
        # remove 0 scored imgs
        imgs = imgs.compact.select{ |x| x[0] > 0 }
        
        # sort in descending score order
        imgs.sort_by!{|x| -x[0]}
        

      end
    end
  end
end