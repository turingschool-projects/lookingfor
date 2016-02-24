require 'rails_helper'

describe HomeController do
  describe 'GET #index' do
    it 'populates a count of jobs' do
      2.times { create(:job) }
      get :index
      expect(assigns(:jobs).count).to eq(2)
    end

    it 'populates a count of companies' do
      3.times { create(:company) }
      get :index
      expect(assigns(:company_count)).to eq(3)
    end

    it 'populates an array of technology names' do
      tech = create(:technology)
      get :index
      expect(assigns(:tech_names)).to match([tech.name])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'orders the jobs by posted date in descending order' do
      job1 = create(:job, posted_date: Date.parse('1/1/2001'))
      job2 = create(:job, posted_date: Date.parse('2/1/2000'))
      job3 = create(:job, posted_date: Date.parse('1/1/2005'))

      get :index
      expect(assigns(:jobs)).to eq [job3, job1, job2]
    end
  end
end
