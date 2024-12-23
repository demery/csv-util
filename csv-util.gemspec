# frozen_string_literal: true

require_relative 'lib/csv_util/version'

Gem::Specification.new do |spec|
  spec.name = 'csv-util'
  spec.version = CSVUtil::VERSION
  spec.authors = ['R. Douglas Emery']
  spec.email = ['doug.emery@gmail.com']

  spec.summary = 'Tools for working with CSV files.'
  spec.description = 'Tools for working with CSV files.'
  spec.homepage = 'https://github.com/demery/csv-util'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata['allowed_push_host'] = 'TODO: Set to your gem server 'https://example.com''

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/demery/csv-util'
  # spec.metadata['changelog_uri'] = 'TODO: Put your gem's CHANGELOG.md URL here.'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files`.split($/).reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'activesupport', '~> 5.0'

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'upennlib-rubocop', '~> 1.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
