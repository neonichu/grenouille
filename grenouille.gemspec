# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grenouille/version'

Gem::Specification.new do |spec|
  spec.name          = 'grenouille'
  spec.version       = Grenouille::VERSION
  spec.authors       = ['Boris Bügling']
  spec.email         = ['boris@buegling.com']
  spec.summary       = 'Automatically detect Swift versions from source code.'
  spec.homepage      = 'https://github.com/neonichu/grenouille'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
