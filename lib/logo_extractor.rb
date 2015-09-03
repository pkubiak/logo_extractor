#require "logo_extractor/version"

#TODO: handling uri data, e.g. data:image/svg+xml;
#TODO: normalize scores from different handlers !!!
#TODO: maybe extractors should share Nokogiri context?
#TODO: add option to extract pure image logo eg. via data-uri
#TODO: distinguish extract_url -> url & extract -> image

module LogoExtractor

  def LogoExtractor.extract_all(url, handler = :all)
    url = URI.escape(url)
    @handlers ||= {}
    if handler == :all then
      x = @handlers.flat_map{ |k,v| if v then v.call(url) else nil end }.compact.sort_by{ |x| -x[0] }
    elsif @handlers[handler] then
      @handlers[handler].call(url)
    else
      nil
    end
  end
  
  # Extract only this link which should be interpreted as logo
  def LogoExtractor.extract(url)
    x = LogoExtractor.extract_all(url).first
    if x then
      x[1]
    end
  end
  
  def LogoExtractor.register_handler(name, &block)
    @handlers ||= {}
    @handlers[name] = block
  end
  
  def LogoExtractor.handlers
    return @handlers.keys
  end
end

require "logo_extractor/handlers/html_handler"
require "logo_extractor/handlers/css_handler"
require "logo_extractor/handlers/favicon_handler"
