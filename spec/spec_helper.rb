require "bundler/setup"
require "dotenv/load"
require "zesty"
require "vcr"
require "webmock/rspec"
require "rspec/json_expectations"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random

  config.include RSpec::JsonExpectations::Matchers
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.default_cassette_options = { record: (ENV['RECORD_MODE'] || :once).to_sym }
  c.filter_sensitive_data('<EMAIL>') { ENV['EMAIL'] }
  c.filter_sensitive_data('<PASSWORD>') { ENV['PASSWORD'] }
  c.filter_sensitive_data('<INSTANCE_ZUID>') { ENV['INSTANCE_ZUID'] }
  c.filter_sensitive_data('<BEARER_TOKEN>') do |interaction|
    interaction.request.headers['Authorization']&.first&.gsub(/Bearer\s+/i, '')
  end
  c.filter_sensitive_data('<TOKEN>') do |interaction|
    if interaction.response.body.include?("token")
      interaction.response.body.match(/token\"\:\"(.*?)\"/i).captures.first
    end
  end
end

AUTH_TOKEN_REGEX = /([a-zA-Z0-9]+)/
TIMESTAMP_REGEX = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z/
