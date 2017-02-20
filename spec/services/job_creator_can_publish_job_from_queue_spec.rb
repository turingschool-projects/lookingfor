require 'rails_helper'
require 'webmock/rspec'

describe JobCreator do
  context 'subscribing to a queue with a job that exists' do
    it 'gets the job and creates it' do
      WebMock.stub_request(:get, 'https://localhost:3001/companies/find?name=Granicus').to_return("{\"company_id\":1}")

      response = Faraday.get("https://localhost:3001/companies/find?name=Granicus", {ssl: {verify: false}})
      expect(response).to eq("{\"company_id\":1}")
    end
  end
end
