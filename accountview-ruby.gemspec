# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'accountview/version'

Gem::Specification.new do |spec|
  spec.name          = 'accountview-ruby'
  spec.version       = Accountview::VERSION
  spec.authors       = ['ForecastXL']
  spec.email         = ['developers@forecastxl.com']
  spec.summary       = %q{Ruby wrapper for Accountview REST API}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'oauth2'
  spec.add_dependency 'json'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'deep_merge'

  # Development / testing
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  # Testing
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
