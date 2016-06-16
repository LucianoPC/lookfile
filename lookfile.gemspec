# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lookfile/version'

Gem::Specification.new do |spec|
  spec.name          = 'lookfile'
  spec.version       = Lookfile::VERSION
  spec.authors       = ['Luciano Prestes Cavalcanti']
  spec.email         = ['lucianopcbr@gmail.com']

  spec.summary       = 'A program to look files'
  spec.description   = 'Version your configuration files'
  spec.homepage      = 'https://github.com/LucianoPC/lookfile'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables << 'lookfile'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
