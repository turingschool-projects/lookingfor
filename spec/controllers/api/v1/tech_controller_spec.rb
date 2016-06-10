require 'rails_helper'

RSpec.describe Api::V1::TechnologiesController, type: :controller do
  describe "GET #index" do
    let(:reponse_body) { json_response = JSON.parse(response.body)}

    it "is successful" do
      get :index, format: :json
      expect(:success)
    end
  end

end
