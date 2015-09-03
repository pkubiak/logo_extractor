# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logo_extractor/version'

Gem::Specification.new do |spec|
  spec.name          = "logo_extractor"
  spec.version       = LogoExtractor::VERSION
  spec.authors       = ["pkubiak"]
  spec.email         = ["solmyrmag@gmail.com"]
  spec.summary       = 'Gem for extracting logo from given url'
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = "https://github.com/pkubiak/logo_extractor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  
  spec.add_runtime_dependency 'css_parser'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'open-uri'
  spec.add_runtime_dependency 'open_uri_redirections'
  spec.add_runtime_dependency 'tempfile'
end
