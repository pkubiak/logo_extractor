#require "logo_extractor/version"


module LogoExtractor

  def LogoExtractor.extract(url, handler = :all)
    url = URI.escape(url)
    @handlers ||= {}
    if handler == :all then
      @handlers.flat_map{ |k,v| if v then v.call(url) else nil end }.compact.sort_by{ |x| -x[0] }
    elsif @handlers[handler] then
      @handlers[handler].call(url)
    else
      nil
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