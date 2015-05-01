# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chef_life/version'

Gem::Specification.new do |spec|
  spec.name = 'chef_life'
  spec.version = ChefLife::VERSION
  spec.authors = ['jmanero']
  spec.email = ['john.manero@gmail.com']
  spec.summary = 'Humane lifecycle management for cookbooks'
  spec.description = IO.read(File.expand_path('../README.md', __FILE__))
  spec.homepage = 'https://github.com/jmanero/chef_life'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk', '~> 2.0'
  spec.add_dependency 'chef', '~> 12.0'
  spec.add_dependency 'ignorefile'
  spec.add_dependency 'thor'
  spec.add_dependency 'thor-scmversion', '1.7.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
end
