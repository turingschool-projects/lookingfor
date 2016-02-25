require 'rails_helper'

feature 'listing jobs' do

  def list_setup
    company1 = create(:company, name: 'Test Company 1')
    company2 = create(:company, name: 'Test Company 2')

    job1 = create(:job, posted_date: Date.parse('January 1, 2000'))
    job1.technologies << create(:technology, name: 'Test Technology 1')
    job1.technologies << create(:technology, name: 'Test Technology 2')

    job2 = create(:job, posted_date: Date.parse('January 1, 2001'), company: company1)
    job2.technologies << create(:technology, name: 'Test Technology 3')

    create(:job, posted_date: Date.parse('January 1, 2002'), company: company2)
  end

  def pagination_setup
    (1..25).each do |num|
      create(:job, title: 'job ' + num.to_s, posted_date: Date.today - num)
    end
  end

  it 'can list jobs by posted date' do
    list_setup
    visit '/'

    within('ul.job-list li:nth-child(1)') do
      expect(page).to have_content 'January 1, 2002'
      expect(page).to have_content 'Test Company 2'
      expect(page).to_not have_content 'Test Technology 1'
      expect(page).to_not have_content 'Test Technology 2'
    end

    within('ul.job-list li:nth-child(2)') do
      expect(page).to have_content 'January 1, 2001'
      expect(page).to have_content 'Test Company 1'
      expect(page).to have_content 'Test Technology 3'
      expect(page).to_not have_content 'Test Technology 1'
      expect(page).to_not have_content 'Test Technology 2'
    end

    within('ul.job-list li:nth-child(3)') do
      expect(page).to have_content 'January 1, 2000'
      expect(page).to have_content 'Test Technology 1'
      expect(page).to have_content 'Test Technology 2'
      expect(page).to_not have_content 'Test Technology 3'
    end
  end

  it 'lists 20 jobs per page' do
    pagination_setup
    visit '/'

    expect(page).to have_content 'Job 20'
    expect(page).to_not have_content 'Job 21'
    click_on 'Next'
    expect(page).to have_content 'Job 21'
    expect(page).to_not have_content 'Job 20'
  end

end
