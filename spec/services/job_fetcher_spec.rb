require 'rails_helper'

describe JobFetcher do
  let(:sample_raw_entry){{
    job: {
      title: "Node Instrumentation Engineer at New Relic (Portland, OR)",
      url: "http://stackoverflow.com/jobs/109010/node-instrumentation-engineer-new-relic",
      location: "Portland Oregon",
      raw_technologies: ["c++", "python", "java", "php", "ruby"],
      description: "<p><strong>New Relic<br></strong><strong>",
      remote: false,
      posted_date: "2016-02-15 16:52:38 UTC" },
    company: {
      name: "New Relic"
    }
  }}

  let(:subject){ JobFetcher }

  describe '.create_records' do
    let(:action){ subject.create_records(sample_raw_entry) }

    context 'when no matching company record exists' do
      it 'creates a company record' do
        expect{ action }.to change{ Company.count }.from(0).to(1)
      end

      it 'sets the name on company record' do
        action
        expect(Company.last.name).to eq(sample_raw_entry[:company][:name])
      end

      it 'assigns a job to existing company' do
        action
        expect(Company.last.jobs.count).to eq(1)
      end
    end

    context 'with an existing company' do
      let(:company_name){ "new relic" }
      let!(:company){ create(:company, name: company_name) }

      it 'does not create another company' do
        expect{ action }.to_not change{ Company.count }
      end

      it 'does assigns a job to existing company' do
        expect{ action }.to change{ company.jobs.count }.from(0).to(1)
      end
    end
  end

  describe '.create_job' do
    let(:company){ create(:company) }
    let(:action){ subject.create_job(sample_raw_entry[:job], company) }
    context 'when no matching job exists' do
      it 'it creates a job belonging to a company' do
        expect{ action }.to change{ company.jobs.count }.from(0).to(1)
      end

      it 'sets the correct attributes on the created job' do
        action
        job = Job.last
        job_entry = sample_raw_entry[:job]
        expect(job.title).to eq(job_entry[:title])
        expect(job.description).to eq(job_entry[:description])
        expect(job.url).to eq(job_entry[:url])
        expect(job.location).to eq(job_entry[:location])
        expect(job.raw_technologies).to eq(job_entry[:raw_technologies])
        expect(job.remote).to eq(job_entry[:remote])
        expect(job.posted_date).to eq(job_entry[:posted_date].to_date)
      end

      it 'assigns technologies' do
        existing_tech = create(:technology, name: 'ruby')
        action
        expect(Job.last.technologies.first).to eq(existing_tech)
      end
    end
    context 'when matching job exists' do
      it 'it does not create a duplicate job' do
        action
        expect{ action }.to_not change{ company.jobs.count }
        expect{ action }.to_not change{ Job.count }
      end
    end
  end
end
