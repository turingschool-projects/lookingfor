require 'spec_helper'

describe JobDecorator do

  describe '.decorated_title' do
    it 'titleizes the title' do
      job1 = create(:job, title: 'Test Job 1').decorate
      job2 = create(:job, title: 'test job 2').decorate

      expect(job1.decorated_title).to eq('Test Job 1')
      expect(job2.decorated_title).to eq('Test Job 2')
    end
  end

  describe '.decorated_date' do
    it 'formats the date' do
      job1 = create(:job, posted_date: Date.parse('1/1/2000')).decorate
      job2 = create(:job, posted_date: Date.parse('Feb 2, 2001')).decorate

      expect(job1.decorated_date).to eq('January  1, 2000')
      expect(job2.decorated_date).to eq('February  2, 2001')
    end
  end

  describe '.company_name' do
    it 'returns the name of a company or N/A' do
      company = create(:company, name: 'Test Company')
      decorator1 = create(:job, company: company).decorate
      decorator2 = create(:job, company: nil).decorate

      expect(decorator1.company_name).to eq('Test Company')
      expect(decorator2.company_name).to eq('N/A')
    end
  end

  describe '.tech_names' do
    it 'returns empty collection or a collection of technologies' do
      job = create(:job).decorate
      expect(job.tech_names).to eq([])

      job.technologies << create(:technology, name: 'Test Technology 1')
      expect(job.tech_names).to eq(['test technology 1'])

      job.technologies << create(:technology, name: 'Test Technology 2')
      expect(job.tech_names).to eq(['test technology 1', 'test technology 2'])
    end
  end
end
