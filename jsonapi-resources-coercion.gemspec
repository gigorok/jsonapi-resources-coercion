# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi/resources/coercion/version'

Gem::Specification.new do |spec|
  spec.name          = 'jsonapi-resources-coercion'
  spec.version       = JSONAPI::Resources::Coercion::VERSION
  spec.authors       = ['Igor Gonchar']
  spec.email         = ['igor.g@didww.com']

  spec.summary       = 'Easily filters type coercion in jsonapi-resources.'
  spec.homepage      = 'https://github.com/gigorok/jsonapi-resources-coercion'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'jsonapi-resources'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

end
