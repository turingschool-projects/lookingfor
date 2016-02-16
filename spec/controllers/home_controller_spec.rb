require 'rails_helper'

describe HomeController do
  describe 'GET #index' do
    it 'populates a count of jobs' do
      2.times { create(:job) }
      get :index
      expect(assigns(:job_count)).to eq(2)
    end

    it 'populates a count of companies' do
      3.times { create(:company) }
      get :index
      expect(assigns(:company_count)).to eq(3)
    end

    it "populates an array of technology names" do
      tech = create(:technology)
      get :index
      expect(assigns(:tech_names)).to match([tech.name])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
