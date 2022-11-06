# frozen_string_literal: true

require_relative 'lib/intention/version'

Gem::Specification.new do |spec|
  spec.name = 'intention'
  spec.version = Intention::VERSION
  spec.authors = ['Lucas Winningham']
  spec.email = ['lucas.winningham@gmail.com']

  spec.summary = 'Ruby gem with the greatest intentions (for hash objects).'
  spec.description = <<-DESCRIPTION
    Intention is a ...
    Should fill this in.
  DESCRIPTION
  spec.homepage = 'https://github.com/lucaswinningham/intention'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lucaswinningham/intention'
  spec.metadata['changelog_uri'] = 'https://github.com/rubocop/rubocop/blob/main/CHANGELOG.md'

  spec.files = Dir.glob('lib/**/*', File::FNM_DOTMATCH)
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.15'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
