require 'rails_helper'

RSpec.describe Api::V1::TrendsController, type: :controller do

  describe "GET #current_openings_technology_count" do

    let(:response_body) { JSON.parse(response.body) }

    it "is successful" do
      get :current_openings_technology_count, format: :json

      expect(:success)
    end

    it 'returns technologies and counts' do
      job1 = create(:job)
      job2 = create(:job)
      job3 = create(:job)
      job3.raw_technologies = job2.raw_technologies
      tech1 = Technology.create(name: job1.raw_technologies[0])
      tech2 = Technology.create(name: job2.raw_technologies[0])
      job1.assign_tech
      job2.assign_tech
      job3.assign_tech

      get :current_openings_technology_count, format: :json

      expect(response_body['trends'].count).to eq(2)
      expect(response_body['trends'][0]).to eq([tech1.name, 1])
      expect(response_body['trends'][1]).to eq([tech2.name, 2])
    end
  end
end
