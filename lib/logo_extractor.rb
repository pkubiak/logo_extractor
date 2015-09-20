#require "logo_extractor/version"

#TODO: handling uri data, e.g. data:image/svg+xml;
#TODO: distinguish extract_url -> url & extract -> image
#TODO: add progressiv handler execution (next only if first doesnt return good results)
#TODO: add points for SVG
module LogoExtractor
  FORMAT_CRITERIONS = [:is_svg, :is_png, :is_jpg, :is_gif, :is_bmp]
  KEYWORDS_CRITERIONS = [:keyword_in_class, :keyword_in_alt, :keyword_in_title, :keyword_in_src, :keyword_in_id]
  
  KEYWORDS = {
    'logo' => 10,
    'logos' => -5,
  }
  
  #TODO: implement
  def LogoExtractor.score(criterions)
    return 0
  end
  
  def LogoExtractor.extract_all(url, handler = :all)
    url = URI.escape(url)
    @handlers ||= {}
    result = if handler == :all then
      x = @handlers.flat_map{ |k,v| if v then v.call(url) else nil end }.compact
    elsif @handlers[handler] then
      @handlers[handler].call(url).compact
    else
      []
    end
    
    result.map{|crit, url| [score(crit), url, crit]}.sort_by{|x| x[0]}
  end

  # Extract only this link which should be interpreted as logo
  def LogoExtractor.extract(url)
    x = LogoExtractor.extract_all(url).first
    if x then
      x[1]
    end
  end

  def LogoExtractor.register_handler(name, criterions, &block)
    @handlers ||= {}
    @handlers[name] = block
  end

  def LogoExtractor.handlers
    return @handlers.keys
  end
end

#Include available handlers
require "logo_extractor/handlers/html_handler"
#require "logo_extractor/handlers/css_handler"
#require "logo_extractor/handlers/favicon_handler"
