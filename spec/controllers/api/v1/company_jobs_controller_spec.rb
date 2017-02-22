require 'rails_helper'

RSpec.describe Api::V1::CompanyJobsController, type: :controller do
  describe "GET #index" do
    context "with monocle id" do
      it "returns a list of jobs at that company" do
        company = Company.create(name: 'test', monocle_id: 1)
        company.jobs << [Job.create(title: 'job 1'), Job.create(title: 'job 2')]
        binding.pry


      end
    end
  end
end
