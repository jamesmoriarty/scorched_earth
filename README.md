# ScorchedEarth

[![Code Climate](https://codeclimate.com/github/jamesmoriarty/scorched-earth-rb/badges/gpa.svg)](https://codeclimate.com/github/jamesmoriarty/scorched-earth-rb) [![Test Coverage](https://codeclimate.com/github/jamesmoriarty/scorched-earth-rb/badges/coverage.svg)](https://codeclimate.com/github/jamesmoriarty/scorched-earth-rb/coverage)

A little [Scorched Earth](https://en.wikipedia.org/wiki/ScorchedEarth_Earth_&#40;video_game&#41;) clone in the Ruby Programming Language (JRuby). Now including a segue into procedurally generated color palettes:
- [TriadMixing](http://devmag.org.za/2012/07/29/how-to-choose-colours-procedurally-algorithms/)
- [CIE94](https://en.wikipedia.org/wiki/Color_difference#CIE94)

![Color Palettes](https://pbs.twimg.com/media/CsYukUuUMAECQG3.jpg)

## Installation

    $ brew install jruby
    $ jruby -S gem install scorched_earth --pre

## Usage

    $ jruby -S scorched

## Development

    $ uname
    Darwin
    $ jruby --version              
    jruby 9.1.5.0 (2.3.1) 2016-09-07 036ce39 Java HotSpot(TM) 64-Bit Server VM 25.74-b02 on 1.8.0_74-b02 +jit [darwin-x86_64]
    $ jruby -S bundle exec rake

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/scorched. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
