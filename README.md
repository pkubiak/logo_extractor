# LogoExtractor [![Code Climate](https://codeclimate.com/github/pkubiak/logo_extractor/badges/gpa.svg)](https://codeclimate.com/github/pkubiak/logo_extractor) [![Test Coverage](https://codeclimate.com/github/pkubiak/logo_extractor/badges/coverage.svg)](https://codeclimate.com/github/pkubiak/logo_extractor/coverage)

Gem for extracting logo from given url.

## Installation

Provisionally only by github.


    $ git clone https://github.com/pkubiak/logo_extractor.git
    $ cd logo_extractor
    $ gem build logo_extractor.gemspec
    $ gem install logo_extractor-0.0.1.gem

or as unprivileged user:

    $ gem install --user-install logo_extractor-0.0.1.gem

Then if you have ruby in your PATH (otherwise by digging into your gems directory):

    $ logo_extractor.app URL

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
