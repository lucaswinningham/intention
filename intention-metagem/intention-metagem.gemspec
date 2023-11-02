lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'intention/version'

Gem::Specification.new do |spec|
  spec.name = 'intention'
  spec.version = Intention::Version::STRING
  spec.authors = ['Lucas Winningham']
  spec.email = ['lucas.winningham@gmail.com']

  spec.summary = 'Ruby gem with the greatest intentions (for hash objects).'
  spec.description = 'Ruby gem with the greatest intentions (for hash objects).'
  spec.homepage = 'https://github.com/lucaswinningham/intention'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/lucaswinningham/intention/intention-metagem/issues',
    'source_code_uri' => 'https://github.com/lucaswinningham/intention/intention-metagem',
    'rubygems_mfa_required' => 'true',
  }

  spec.files = Dir.glob('lib/**/*', File::FNM_DOTMATCH)
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # # TODO: address!

  dependency_version = "~> #{Intention::Version::STRING.split('.')[0..1].push('0').join('.')}"

  if Intention::Version::STRING =~ /[a-zA-Z]+/
    dependency_version = "= #{Intention::Version::STRING}"
  end

  %w[core access ingestion validation].each do |name|
    spec.add_runtime_dependency "intention-#{name}", dependency_version
  end
end
