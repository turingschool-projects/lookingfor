require 'factory_girl_rails'

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
  config.before(:each) do
    stub_request(:any, /authenticjobs.com/).to_rack(FakeAuthenticJobs)
  end
end
