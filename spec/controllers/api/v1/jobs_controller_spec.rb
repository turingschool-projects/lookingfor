require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  describe "GET #index" do
    let(:response_body) { json_response = JSON.parse(response.body) }

    it "is successful" do
      get :index, format: :json

      expect(:success)
    end

    it 'returns json default of 25 jobs' do
      30.times { create(:job) }
      get :index, format: :json

      expect(response_body['jobs'].count).to eq(25)
    end

    it 'returns jobs with correct attributes' do
      create(:job)
      get :index, format: :json

      response_body['jobs'].each do |job|
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
      company = response_body['jobs'].first['company']

      expect(company['id']).to be_instance_of(Fixnum)
      expect(company['name']).to be_instance_of(String)
    end

    it 'includes remaining jobs on next page of pagination' do
      30.times { create(:job) }
      get :index, page: 2

      expect(response_body['jobs'].count).to eq(5)
    end

    it 'capitalizes technologies appropriately' do
      job = create(:job)
      downcased_technologies = ["javascript", "clojure", "new relic"]
      downcased_technologies.map {|t| job.technologies << create(:technology, name: t)}

      get :index

      response_body["jobs"].first["technologies"].each_with_index do | tech, i |
        expect(["JavaScript", "Clojure", "New Relic"]).to include(tech["name"])
      end
    end

    it "takes in optional parameters for type of technology" do
      ruby_job = create(:job)
      other_job = create(:job)
      ruby_job.technologies << create(:technology, name: "ruby")
      other_job.technologies << create(:technology, name: "other")

      get :index, {technology: "ruby"}

      expect(response_body["jobs"].count).to eq(1)
      response_body["jobs"].each do |job|
        expect(job["technologies"].first["name"]).to eq("Ruby")
        expect(job["id"]).to eq(ruby_job.id)
      end
    end

    it "returns multiple jobs for technology parameter" do
      create_list(:job, 4)
      tech = create(:technology, name: "ruby")
      Job.find_each {|job| job.technologies << tech}

      get :index, {technology: "ruby"}

      expect(response_body["jobs"].count).to eq(4)
      response_body["jobs"].each do |job|
        expect(job["technologies"].first["name"]).to eq("Ruby")
      end
    end
  end

  describe "GET #show" do
    let(:response_body) { JSON.parse(response.body) }
    let(:job) { create(:job) }

    it "is successful" do
      get :show, id: job.id, format: :json

      expect(:success)
    end

    it 'returns job with correct attributes' do
      get :show, id: job.id, format: :json
      json_job = response_body['job']

      expect(json_job['title']).to be_instance_of(String)
      expect(json_job['description']).to be_instance_of(String)
      expect(json_job['url']).to be_instance_of(String)
      expect(json_job['location']).to be_instance_of(String)
      expect(json_job['posted_date']).to be_instance_of(String)
      expect(json_job['remote']).to be false
      expect(json_job['technologies']).to be_instance_of(Array)
      expect(json_job['company']).to be_instance_of(Hash)
    end
  end
end
