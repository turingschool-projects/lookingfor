require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do

  describe "GET #index" do

    let(:response_body) { JSON.parse(response.body) }

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

  describe "GET #by_company" do
    let(:response_body) { JSON.parse(response.body) }
    let(:company) { create(:company) }
    let(:job1) { create(:job, company_id: company.id, posted_date: Date.parse('1/1/2001')) }
    let(:job2) { create(:job, company_id: company.id, posted_date: Date.parse('2/1/2000')) }
    let(:job3) { create(:job, company_id: company.id, posted_date: Date.parse('1/1/2005')) }
    let(:job4) { create(:job, company_id: company.id + 1, posted_date: Date.parse('1/1/2005')) }

    it "is successful" do
      get :by_company, id: company.id, format: :json

      expect(:success)
    end

    it 'returns all jobs for the company ordered by posted date in descending order' do
      get :by_company, id: company.id, format: :json
      json_jobs = response_body['jobs']
      require 'pry'; binding.pry

      expect(response_body).to eq [job3, job1, job2]
    end
  end
end
