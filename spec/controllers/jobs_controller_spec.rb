require 'rails_helper'

describe JobsController do
  describe 'GET #show' do

    it 'renders the :show view' do
      job = create(:job)
      get :show, id: job.id

      expect(response).to render_template :show
    end

    it 'renders the correct job listing' do
      job = create(:job)
      job2 = create(:job)
      get :show, id: job.id

      expect(assigns(:job)).to eq (job)
    end

  end
end
