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

  describe '.pull_description' do
    it 'pulls a description from a summary' do
      summary = "<img alt='logo' src='mylogo'/>\n\n\n" +
                "<strong>Headquarters:</strong> Denver\n\n\n" +
                "<div>The job description</div>\n\n\n" +
                "To Apply: Things to do.\n"
      description = service.pull_description(summary)

      expect(description).to eq('The job description')
    end
  end
end
