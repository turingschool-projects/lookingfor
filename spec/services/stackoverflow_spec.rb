require 'rails_helper'

describe StackOverflow do
  describe '.pull_company_name' do
    it 'pulls a company from a title' do
      title = "Principal Software Engineer at Comcast (Philadelphia, PA)"
      company_name = StackOverflow.pull_company_name(title)
      expect(company_name).to eq('Comcast')
    end

    it 'handles unmatching pattern' do
      title = "Principal Software Engineer Comcast (Philadelphia, PA)"
      company_name = StackOverflow.pull_company_name(title)
      expect(company_name).to eq('')
    end
  end

  describe '.pull_location' do
    it 'pulls a location from a title' do
      title = "Principal Software Engineer at Comcast (Philadelphia, PA)"
      company_name = StackOverflow.pull_location(title)
      expect(company_name).to eq('Philadelphia, PA')
    end

    it 'handles unmatching pattern' do
      title = "Principal Software Engineer at Comcast"
      company_name = StackOverflow.pull_location(title)
      expect(company_name).to eq('')
    end
  end
end
