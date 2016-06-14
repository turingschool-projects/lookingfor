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
      job1.location.update_attributes(name: "DENVER")

      job2 = create(:job)
      job2.location.update_attributes(name: "DENVEr")

      job3 = create(:job)
      job3.location.update_attributes(name: "Hawaii")

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
      two_month_job.update_attributes(posted_date: 2.months.ago)
      two_month_job.location.update_attributes(name: "DENVER")

      one_month_job = create(:job)
      one_month_job.update_attributes(posted_date: 1.months.ago)
      one_month_job.location.update_attributes(name: "DENVer")
      
      current_job = create(:job)
      current_job.location.update_attributes(name: "DENVEr")

      get :index, { location: "Denver" }, format: :json

      expect(response_body['recent_jobs'].count).to eq(2)
      expect(response_body['recent_jobs'].first["title"]).to eq(current_job.title)
      expect(response_body['recent_jobs'].last["title"]).to eq(one_month_job.title)
    end

    it "is successful with technology params" do
      get :index, { technology: "rails" }, format: :json

      expect(:success)
    end

    it 'capitalizes technologies appropriately' do
      job = create(:job)
      downcased_technologies = ["javascript", "clojure", "new relic"]
      downcased_technologies.map {|t| job.technologies << create(:technology, name: t)}

      get :index

      response_body["recent_jobs"].first["technologies"].each_with_index do | tech, i |
        expect(["JavaScript", "Clojure", "New Relic"]).to include(tech["name"])
      end
    end

    it "takes in optional parameters for type of technology" do
      ruby_job = create(:job)
      other_job = create(:job)
      ruby_job.technologies << create(:technology, name: "ruby")
      other_job.technologies << create(:technology, name: "other")

      get :index, {technology: "ruby"}

      expect(response_body["recent_jobs"].count).to eq(1)
      response_body["recent_jobs"].each do |job|
        expect(job["technologies"].first["name"]).to eq("Ruby")
        expect(job["id"]).to eq(ruby_job.id)
      end
    end

    it "returns multiple recent jobs for technology parameter" do
      create_list(:job, 4)
      tech = create(:technology, name: "ruby")
      Job.find_each {|job| job.technologies << tech}

      get :index, {technology: "ruby"}

      expect(response_body["recent_jobs"].count).to eq(4)
      response_body["recent_jobs"].each do |job|
        expect(job["technologies"].first["name"]).to eq("Ruby")
      end
    end
  end
end
