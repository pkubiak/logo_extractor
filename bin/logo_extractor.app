#! /usr/bin/env ruby

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require "logo_extractor"

logo = LogoExtractor.extract(ARGV[0], 'html-img').first
if logo then
  puts logo[1]
end