require "rails_helper"

RSpec.describe Api::V1::CompanyJobsController, type: :controller do
  describe "GET #index" do
    context "with monocle id" do
      it "returns a list of jobs at that company" do
        company = Company.create(name: 'test', monocle_id: 1)
        company.jobs << [Job.create(title: 'job 1'), Job.create(title: 'job 2')]

        get :index, monocle_id: company.monocle_id, format: :json

        jobs = JSON.parse(response.body, symbolize_names: true)[:company_jobs]

        expect(response).to have_http_status(200)
        expect(jobs.count).to eq(2)
        expect(jobs.first[:title]).to eq('job 1')
        expect(jobs.second[:title]).to eq('job 2')
      end
    end
  end
end
