require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'css_parser'
require 'tmpdir'
require 'tempfile'
require 'base64'

# Extractor for favicon with rating based on icon size
# ! there is probably not false results

#TODO: relative paths
#TODO: when image type is ico, extract each layer separately
module LogoExtractor
  module Handlers
    class FaviconHandler
      #CONVERTER = !system('convert --version').nil?
      
      def FaviconHandler.extract_ico_file(path)
        pwd = Dir.pwd
        begin
          Dir.mktmpdir do |dir|
            # load remote icon to local tmp file
            f = Tempfile.new(['logo_extractor','.ico'], dir)
            f.puts(open(path).read)
            f.close
            
            Dir.chdir dir
            
            # convert ico to png/pngs
            cmd = "convert #{f.path} ./output.png"
            puts cmd
            system(cmd)
            
            #scan directory for 'output.png' or 'output-[0-9]+.png'
            if Dir.glob('output*.png').length > 1 then
              return Dir.glob('output*.png').map do |out|
                ['data:image/png;base64,',Base64.strict_encode64(open(out).read)].join
              end
            else
              #In case when there is only single file, return original url
              return [path]
            end
          end
        ensure
          Dir.chdir pwd #return to original path
        end
      end
      
      LogoExtractor.register_handler 'favicon' do |url|
        doc = Nokogiri::HTML(open(url, :allow_redirections => :all))
        
        #determine base url
        base = url
        doc.css('base').each do |url|
          base = url.attr('href') || base
        end
        
        results = []
        
        #TODO: check favicon.ico
        
        # checking icons defined in link tags
               
        # how each icon type is important
        weights = {
          'shortcuticon' => 10,
          'icon' => 20,
          'appletouchicon' => 5,
        }
        
        sizes = /^([0-9]+)x([0-9]+)$/
        
        doc.css('link').each do |link|
          if link.attr('rel') and link.attr('href') then
            #remove special characters, leave only [a-z]
            rel = link.attr('rel').downcase.each_char.map{|x| (('a'..'z').include? x) ? x : nil }.compact.join
            
            if weights.has_key? rel then
              # base weight depending on icon type
              weight = weights[rel]
              
              # try parse icon size from tags
              match = sizes.match(link.attr('sizes') || '')
              if match then
                weight += Math.sqrt(match[1].to_i*match[2].to_i).to_i
              end
              
              #TODO: try to compute size when it is not given
              
              results.push([weight, URI.join(base, URI.escape(link.attr('href'))).to_s])
            end
          end
        end
        
        results
      end
    end
  end
end