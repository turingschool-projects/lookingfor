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

    context "with wrong query params" do
      it "returns an error message with relevant status code" do
        get :index, monocle_id: 1, format: :json

        parsed_response = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(500)
        expect(parsed_response[:error]).to eq("Query error")
      end
    end
  end
end
