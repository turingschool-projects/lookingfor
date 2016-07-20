require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :controller do

  describe "GET #show" do
    let(:response_body) { JSON.parse(response.body) }
    let(:company) { create(:company) }

    it "is successful" do
      get :show, id: company.id, format: :json

      expect(:success)
    end

    it 'returns company with correct attributes' do
      get :show, id: company.id, format: :json
      json_company = response_body['company']

      expect(json_company['name']).to be_instance_of(String)
      expect(json_company['jobs']).to be_instance_of(Array)
    end

    it 'returns all jobs for the company ordered by posted date in descending order' do
      company = create(:company)
      job1 = create(:job, company_id: company.id, posted_date: Date.parse('1/1/2001'))
      job2 = create(:job, company_id: company.id, posted_date: Date.parse('2/1/2000'))
      job3 = create(:job, company_id: company.id, posted_date: Date.parse('1/1/2005'))
      job4 = create(:job, company_id: company.id + 1, posted_date: Date.parse('1/1/2005'))

      get :show, id: company.id, format: :json
      json_jobs = response_body['company']['jobs']

      expect(json_jobs).to eq [job3, job1, job2]
    end
  end
end
