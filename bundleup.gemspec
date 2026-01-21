# frozen_string_literal: true

require_relative 'lib/bundleup/version'

Gem::Specification.new do |spec|
  spec.name          = 'bundleup'
  spec.version       = Bundleup::VERSION
  spec.authors       = ['BundleUp']
  spec.email         = ['support@bundleup.io']

  spec.summary       = 'Official Ruby SDK for BundleUp'
  spec.description   = 'Ruby client library for the BundleUp API'
  spec.homepage      = 'https://github.com/bundleup/bundleup-sdk-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/bundleup/bundleup-sdk-ruby',
    'changelog_uri' => 'https://github.com/bundleup/bundleup-sdk-ruby/blob/main/CHANGELOG.md'
  }

  spec.files         = Dir['lib/**/*', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'faraday-retry', '~> 2.0'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.50'
  spec.add_development_dependency 'vcr', '~> 6.1'
  spec.add_development_dependency 'webmock', '~> 3.18'
end
