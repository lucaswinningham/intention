lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'intention/required/version'

Gem::Specification.new do |spec|
  spec.name = 'intention-required'
  spec.version = Intention::Required::Version::STRING
  spec.authors = ['Lucas Winningham']
  spec.email = ['lucas.winningham@gmail.com']

  spec.summary = "intention-required-#{Intention::Required::Version::STRING}"
  spec.description = 'Ruby gem with the greatest intentions (for hash objects).'
  spec.homepage = 'https://github.com/lucaswinningham/intention-required'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/lucaswinningham/intention/intention-required/issues',
    'source_code_uri' => 'https://github.com/lucaswinningham/intention/intention-required',
    'rubygems_mfa_required' => 'true',
  }

  spec.files = Dir.glob('lib/**/*', File::FNM_DOTMATCH)
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
