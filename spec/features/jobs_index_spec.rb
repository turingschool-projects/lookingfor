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

  it 'lists 20 jobs per page' do
    i = 1
    25.times do
      create(:job, title: 'job ' + i.to_s)
      i += 1
    end
    visit '/'

    expect(page).to have_content 'Job 20'
    expect(page).to_not have_content 'Job 21'
    click_on 'Next'
    expect(page).to have_content 'Job 21'
    expect(page).to_not have_content 'Job 20'
  end

end