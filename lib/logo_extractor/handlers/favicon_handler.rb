require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'css_parser'
require 'tmpdir'
require 'tempfile'
require 'base64'
require 'open3'

# Extractor for favicon with rating based on icon size
# ! there is probably not false results

#TODO: relative paths
module LogoExtractor
  module Handlers
    class FaviconHandler
      # Test if ICO file contains multiple layers and if so extract them as separeted 'files'
      def FaviconHandler.extract_ico_layers(path)
        pwd = Dir.pwd
        begin
          Dir.mktmpdir do |dir|
            # load remote icon to local tmp file
            f = Tempfile.new(['logo_extractor','.ico'], dir)
            t = open(path).read

            return [] if t.length < 30

            f.write(t)
            f.close

            Dir.chdir dir

            # convert ico to png/pngs
            system("convert #{f.path} ./output.png")

            #scan directory for 'output.png' or 'output-[0-9]+.png'
            if Dir.glob('output*.png').length > 1 then
              return Dir.glob('output*.png').map do |out|
                size = {width:0, height: 0}

                o, _ = Open3.capture2('identify', '-format', '%[fx:w],%[fx:h]', out)

                o = o.split(',')

                size = {width: o[0].to_i, height: o[1].to_i}

                [['data:image/png;base64,', Base64.strict_encode64(open(out).read)].join, size, 20]
              end
            else
              #In case when there is only single file, return original url
              return [[path, nil, 20]]
            end
          end
        ensure
          Dir.chdir pwd #return to original path
        end
      end

      # For each icon with missing dimensions, open it and calculate its size (using ImageMagick)
      def FaviconHandler.calculate_missing_sizes(data)
        data.map do |row|
          unless row[1] then
            puts row[0]
            f = Tempfile.new(['logo_extractor',File.extname(URI.parse(row[0]).path)])
            f.write(open(row[0]).read)
            f.close


            out, _ = Open3.capture2('identify', '-format', '%[fx:w],%[fx:h]', f.path)
            out = out.split(',')
            row[1] = {width: out[0].to_i, height: out[1].to_i}

            f.unlink
          end
          row
        end
      end


      def FaviconHandler.extract(url)
        doc = Nokogiri::HTML(open(url, :allow_redirections => :all))

        #determine base url
        base = url
        doc.css('base').each do |url|
          base = url.attr('href') || base
        end

        # temp record structure [url, [width, height], base_score]
        results = []

        #Check if global favicon exists and if so extract them
        begin
          path = URI.join(URI(url), URI('/favicon.ico'))
          open(path)
          results+=FaviconHandler.extract_ico_layers(path.to_s)
        rescue
          # Do nothing
        end

        # how each icon type is important
        weights = {
          'shortcuticon' => 10,
          'icon' => 20,
          'appletouchicon' => 5,
        }

        sizes = /^([0-9]+)x([0-9]+)$/

        # checking icons defined in link tags
        doc.css('link').each do |link|
          if link.attr('rel') and link.attr('href') then
            #remove special characters, leave only [a-z]
            rel = link.attr('rel').downcase.each_char.map{|x| (('a'..'z').include? x) ? x : nil }.compact.join

            if weights.has_key? rel then
              if link.attr('href').downcase.end_with? '.ico' then
                #TODO: better checking if file is ico type
                results+=FaviconHandler.extract_ico_layers(
                  URI.join(base, URI.escape(link.attr('href'))).to_s
                )
              else
                # base weight depending on icon type
                weight = weights[rel]

                # try parse icon size from tags
                match = sizes.match(link.attr('sizes') || '')

                size = match ? {width: match[1].to_i, height: match[2].to_i} : nil

                results.push([URI.join(base, URI.escape(link.attr('href'))).to_s, size, weight])
              end
            end
          end
        end


        # Calculate missing sizes
        results = FaviconHandler.calculate_missing_sizes(results)

        # Convert rows to common structure
        return results.map{|row| [row[2] + Math.sqrt(row[1][:width]*row[1][:height]).to_i, row[0]]}
      end


      # register handler
      LogoExtractor.register_handler 'favicon' do |url|
        FaviconHandler.extract(url)
      end


    end
  end
end
