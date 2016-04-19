require 'rails_helper'

describe CompaniesController do
  describe 'GET #show' do
    it 'only shows jobs related to a specific company' do
      jobs = 2.times { create(:job) }
      job  = create(:job)

      get :show, id: job.company_id

      expect(assigns(:jobs).count).to eq(1)
    end

    it 'renders the :show view' do
      company = create(:company)

      get :show, id: company.id

      expect(response).to render_template :show
    end

    it 'orders the jobs for a company by posted date in descending order' do
      company = create(:company)
      job1 = create(:job, company_id: company.id, posted_date: Date.parse('1/1/2001'))
      job2 = create(:job, company_id: company.id, posted_date: Date.parse('2/1/2000'))
      job3 = create(:job, company_id: company.id, posted_date: Date.parse('1/1/2005'))
      job4 = create(:job, posted_date: Date.parse('1/1/2005'))

      get :show, id: company.id

      expect(assigns(:jobs)).to eq [job3, job1, job2]
    end
  end
end
