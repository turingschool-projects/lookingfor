require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  describe "GET #index" do
    let(:response_body) { json_respone = JSON.parse(response.body) }

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

  describe "GET #last_two_months" do
    let(:response_body) { json_respone = JSON.parse(response.body) }

    it "is successful" do
      get :last_two_months, format: :json

      expect(:success)
    end

    it 'returns jobs with correct attributes' do
      create(:job)
      get :last_two_months, format: :json


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
      get :last_two_months, format: :json
      company = response_body['jobs'].first['company']

      expect(company['id']).to be_instance_of(Fixnum)
      expect(company['name']).to be_instance_of(String)
    end

    it 'only returns jobs posted within the last 2 months' do
      three_month_job = create(:job)
      three_month_job.update(posted_date: 3.months.ago)
      two_month_job = create(:job)
      two_month_job.update(posted_date: 2.months.ago)
      current_job = create(:job)

      get :last_two_months, format: :json

      expect(response_body['jobs'].count).to eq(2)
      expect(response_body['jobs'].first["title"]).to eq(current_job.title)
      expect(response_body['jobs'].last["title"]).to eq(two_month_job.title)
    end
  end
end
