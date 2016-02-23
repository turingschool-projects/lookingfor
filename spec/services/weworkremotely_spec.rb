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

  describe 'parsing the summary' do
    let(:summary) { "\n\n\n" +
                    "Headquarters: Denver, CO URL: example.com\n\n\n" +
                    "The job description\n\n\n" +
                    "To Apply: Things to do.\n" }

    describe '.pull_description' do
      it 'pulls a description from a summary' do
        description = service.pull_description(summary)

        expect(description).to eq('The job description')
      end
    end

    describe '.pull_location' do
      it 'pulls a location from a summary' do
        location = service.pull_location(summary)

        expect(location).to eq('Denver, CO')
      end
    end
  end
end
