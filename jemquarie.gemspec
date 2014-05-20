# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jemquarie/version'

Gem::Specification.new do |spec|
  spec.name          = "jemquarie"
  spec.version       = Jemquarie::VERSION
  spec.authors       = ["Claudio Contin"]
  spec.email         = ["contin@gmail.com"]
  spec.description   = %q{Connect to Macquerie ESI web services}
  spec.summary       = %q{Connect to Macquerie ESI web services}
  spec.homepage      = "http://www.sharesight.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "savon",                    '~> 2.0'
  spec.add_dependency "active_support",           '>= 3.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fakeweb", '~> 1.3.0'
  spec.add_development_dependency "rspec"
end
