#! /usr/bin/env ruby

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'tempfile'
require "logo_extractor"


if ARGV.length > 1 then

  f = Tempfile.new('logo_extractor')
  puts f.path
  f << "<!DOCTYPE html><html><body>"
  f << '<table>'
  ARGV.each do |url|
    logo = LogoExtractor.extract(url)
    f << "<tr><td>#{url}</td><td>"
    f << (logo ? "<img src='#{logo}' />" : "")
    f << "</td></tr>"
  end
  
  f << '</table>'
  f << "</body></html>"
  f.close
  exec('chromium "'+f.path+'"')
else
  logo = LogoExtractor.extract_all(ARGV[0])
  logo.each do |l|
    puts l[0].to_s.rjust(8)+' '+l[1]
  end
  
  logo = logo.first
  if logo then
    exec('display "'+logo[1]+'"')
  end
end