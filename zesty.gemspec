require_relative "lib/zesty/version"

Gem::Specification.new do |spec|
  spec.name = "zesty"
  spec.version = Zesty::VERSION
  spec.authors = ["Javier Julio"]
  spec.email = ["javier@jackpocket.com"]

  spec.summary = "A Ruby interface to the Zesty.io API"
  spec.description = "A Ruby interface to the Zesty.io API. Not all API actions are supported."
  spec.homepage = "https://github.com/jackpocket/zesty-rb"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/jackpocket/zesty-rb/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/jackpocket/zesty-rb/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "http", ">= 4", "< 6"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-json_expectations"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
