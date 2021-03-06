require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'simple_google_drive'
require 'webmock/rspec'

# Allowing codeclimate connections
WebMock.disable_net_connect!(:allow => "codeclimate.com")

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
