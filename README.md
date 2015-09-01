# LogoExtractor

Gem for extracting logo from given url.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'logo_extractor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logo_extractor


## Global TODO
- [ ] Rewrite rspec tests
- [ ] Describe dependencies in gem config
- [ ] Write gemspec
- [ ] Add OptionParser support to logo_extractor.app


## Usage

Simply execute:

```ruby
LogoExtractor.extract(url)
```

which returns array of pair (url rating + logo url).

There is also simply script covering library use cases in `bin/logo_extractor.app`.

## Contributing

1. Fork it ( https://github.com/pkubiak/logo_extractor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
