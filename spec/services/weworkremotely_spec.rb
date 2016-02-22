require 'rails_helper'

describe WeWorkRemotely do
  let(:service){ WeWorkRemotely }

  describe '.pull_company_name' do
    it 'pulls a company from a title' do
      title = "Basecamp Networks: Computer Vision Engineer"
      company_name = service.pull_company_name(title)

      expect(company_name).to eq('Basecamp Networks')
    end

    it 'handles unmatching pattern' do
      title = "Basecamp Networks Computer Vision Engineer"
      company_name = service.pull_company_name(title)

      expect(company_name).to eq('')
    end
  end
end
