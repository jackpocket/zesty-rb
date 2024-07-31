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
  spec.files = Dir["README.md", "LICENSE*", "lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "http", ">= 4", "< 6"
end
