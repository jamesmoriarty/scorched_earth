# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scorched/version'

Gem::Specification.new do |spec|
  spec.name          = "scorched"
  spec.version       = Scorched::VERSION
  spec.authors       = ["James Moriarty"]
  spec.email         = ["jamespaulmoriarty@gmail.com"]
  spec.summary       = %q{A simple clone of the classic game Scorched Earth in Ruby.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ray", "~> 0.2.1"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
