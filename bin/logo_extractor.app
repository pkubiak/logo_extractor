#! /usr/bin/env ruby

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'tempfile'
require "logo_extractor"


puts ARGV
puts ARGV.length
if ARGV.length > 1 then

  f = Tempfile.new('logo_extractor')
  puts f.path
  f << "<!DOCTYPE html><html><body>"
  f << '<table>'
  ARGV.each do |url|
    logo = LogoExtractor.extract(url).first
    f << "<tr><td>#{url}</td><td>"
    f << (logo ? "<img src='#{logo[1]}' />" : "")
    f << "</td></tr>"
  end
  
  f << '</table>'
  f << "</body></html>"
  f.close
  exec('chromium "'+f.path+'"')
else
  logo = LogoExtractor.extract(ARGV[0]).first
  if logo then
    exec('display "'+logo[1]+'"')
  end
end