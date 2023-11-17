lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'intention/support/version'

Gem::Specification.new do |spec|
  spec.name = 'intention-support'
  spec.version = Intention::Support::Version::STRING
  spec.authors = ['Lucas Winningham']
  spec.email = ['lucas.winningham@gmail.com']

  spec.summary = "intention-support-#{Intention::Support::Version::STRING}"
  spec.description = 'Ruby gem with the greatest intentions (for hash objects).'
  spec.homepage = 'https://github.com/lucaswinningham/intention-support'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/lucaswinningham/intention/intention-support/issues',
    'source_code_uri' => 'https://github.com/lucaswinningham/intention/intention-support',
    'rubygems_mfa_required' => 'true',
  }

  spec.files = Dir.glob('lib/**/*', File::FNM_DOTMATCH)
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('middleware', '0.1.0')
end
