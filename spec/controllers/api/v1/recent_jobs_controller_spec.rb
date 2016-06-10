require 'rails_helper'

RSpec.describe Api::V1::RecentJobsController, type: :controller do

  describe "GET #index" do
    let(:response_body) { json_response = JSON.parse(response.body) }

    it "is successful" do
      get :index, format: :json

      expect(:success)
    end

    it 'returns jobs with correct attributes' do
      create(:job)
      get :index, format: :json

      response_body['recent_jobs'].each do |job|
        expect(job['title']).to be_instance_of(String)
        expect(job['description']).to be_instance_of(String)
        expect(job['url']).to be_instance_of(String)
        expect(job['location']).to be_instance_of(String)
        expect(job['posted_date']).to be_instance_of(String)
        expect(job['remote']).to be false
        expect(job['company']).to be_instance_of(Hash)
      end
    end

    it 'returns the id and name of the company the job belongs to' do
      create(:job)
      get :index, format: :json
      company = response_body['recent_jobs'].first['company']

      expect(company['id']).to be_instance_of(Fixnum)
      expect(company['name']).to be_instance_of(String)
    end

    it 'only returns jobs posted within the last month' do
      two_month_job = create(:job)
      two_month_job.update(posted_date: 2.months.ago)
      one_month_job = create(:job)
      one_month_job.update(posted_date: 1.month.ago)
      current_job = create(:job)

      get :index, format: :json

      expect(response_body['recent_jobs'].count).to eq(2)
      expect(response_body['recent_jobs'].first["title"]).to eq(current_job.title)
      expect(response_body['recent_jobs'].last["title"]).to eq(one_month_job.title)
    end
  end

  describe "GET #index" do
    let(:response_body) { json_response = JSON.parse(response.body) }

    it "is successful with location params" do
      get :index, { location: "Denver" }, format: :json

      expect(:success)
    end

    it 'returns correct number of jobs for location search' do
      job1 = create(:job)
      job1.update(location: "DENVER")
      job2 = create(:job)
      job2.update(location: "DENVER")
      job3 = create(:job)
      job3.update(location: "Hawaii")
      get :index, { location: "Denver" }, format: :json

      expect(response_body['recent_jobs'].count).to eq(2)

      response_body['recent_jobs'].each do |job|
        expect(job['title']).to be_instance_of(String)
        expect(job['description']).to be_instance_of(String)
        expect(job['url']).to be_instance_of(String)
        expect(job['location']).to be_instance_of(String)
        expect(job['posted_date']).to be_instance_of(String)
        expect(job['remote']).to be false
        expect(job['company']).to be_instance_of(Hash)
      end
    end

    it 'only returns jobs posted within the last month when searching by location' do
      two_month_job = create(:job)
      two_month_job.update(location: "DENVER", posted_date: 2.months.ago)
      one_month_job = create(:job)
      one_month_job.update(location: "DENVER", posted_date: 1.month.ago)
      current_job = create(:job)
      current_job.update(location: "DENVER")

      get :index, { location: "Denver" }, format: :json

      expect(response_body['recent_jobs'].count).to eq(2)
      expect(response_body['recent_jobs'].first["title"]).to eq(current_job.title)
      expect(response_body['recent_jobs'].last["title"]).to eq(one_month_job.title)
    end
  end

end
