# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jemquarie/version'

Gem::Specification.new do |spec|
  spec.name          = "jemquarie"
  spec.version       = Jemquarie::VERSION
  spec.authors       = ["Claudio Contin"]
  spec.email         = ["contin@gmail.com"]
  spec.description   = %q{Connect to Macquarie ESI web services}
  spec.summary       = %q{Ruby Gem for extracting cash transactions from Macquarie ESI web service}
  spec.homepage      = "https://github.com/clod81/jemquarie"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "savon",                   '~> 2.12'
  spec.add_runtime_dependency "activesupport",   '~> 3.0'

  spec.add_development_dependency "bundler",     '~> 1.11'
  spec.add_development_dependency "rake",        '~> 11.2'
  spec.add_development_dependency "webmock",     '~> 3.3'
  spec.add_development_dependency "rspec",       '~> 3.4'
end
