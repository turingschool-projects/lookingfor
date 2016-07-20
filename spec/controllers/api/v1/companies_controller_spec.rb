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

    it 'returns all jobs for the company' do
      company = create(:company)
      job1 = create(:job, company: company)
      job2 = create(:job, company: company)
      job3 = create(:job)

      get :show, id: company.id, format: :json
      json_jobs = response_body['company']['jobs']

      expect(json_jobs.length).to eq(2)
      expect(json_jobs[0]['id']).to eq(job1.id)
      expect(json_jobs[1]['id']).to eq(job2.id)
      expect(json_jobs[0]['title']).to eq(job1.title)
      expect(json_jobs[0]['description']).to eq(job1.description)
      expect(json_jobs[0]['url']).to eq(job1.url)
      expect(json_jobs[0]['remote']).to eq(job1.remote)
      expect(json_jobs[0]['technologies']).to eq(job1.technologies)
    end
  end
end
