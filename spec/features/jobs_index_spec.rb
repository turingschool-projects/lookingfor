require 'rails_helper'

feature 'listing jobs' do
  it 'can list jobs' do
    company1 = create(:company, name: 'Test Company 1')
    company2 = create(:company, name: 'Test Company 2')
    create(:job, posted_date: Date.parse('January 1, 2000'))
    create(:job, posted_date: Date.parse('January 1, 2001'), company: company1)
    create(:job, posted_date: Date.parse('January 1, 2002'), company: company2)
    visit '/'

    within('li', text: 'January 1, 2000') do
      expect(page).to have_content 'Company: N/A'
    end

    within('li', text: 'January 1, 2001') do
      expect(page).to have_content 'Company: Test Company 1'
    end

    within('li', text: 'January 1, 2002') do
      expect(page).to have_content 'Company: Test Company 2'
    end
  end

end