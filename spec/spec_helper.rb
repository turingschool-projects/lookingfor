require 'factory_girl_rails'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter

SimpleCov.start('rails') do
  add_filter 'app/secrets'
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.before(:each) do
    stub_request(:any, /stackoverflow/).to_rack(FakeStackOverflow)
  end
end
