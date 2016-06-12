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
