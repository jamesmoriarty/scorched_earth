# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scorched_earth/version'

Gem::Specification.new do |spec|
  spec.name          = "scorched_earth"
  spec.version       = ScorchedEarth::VERSION
  spec.authors       = ["James Moriarty"]
  spec.email         = ["jamespaulmoriarty@gmail.com"]

  spec.summary       = %q{A simple clone of the classic game ScorchedEarth Earth.}
  spec.homepage      = "https://github.com/jamesmoriarty/scorched-earth/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ray"
  spec.add_dependency "color"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
