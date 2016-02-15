require 'rails_helper'

describe JobFetcher do
  sample_raw_entry = { title: "Lead Software Developer - Consulting & Delivery! at ThoughtWorks (Chicago, IL)",
                     url: "http://stackoverflow.com/jobs/96921/lead-software-developer-consulting-delivery-thoughtworks",
                     company_name: "ThoughtWorks",
                     location: "Chicago, IL",
                     remote: false,
                     technologies: ["java", "javascript", "ruby", "cloud", "continuous-delivery"],
                     description: "<p>Our developers have been contributing code to major organizations and open source projects for over 25 years now. They&rsquo;ve also been writing books, speaking at conferences, and helping push software development forward -- changing companies and even industries along the way.</p><br /><p>As consultants, we work on-site with our clients to ensure we&rsquo;re delivering the best possible solution. Our Lead Dev plays an important role in leading these projects to success.</p><br /><p>Curious what makes a developer a Lead around these parts? <em><strong>A lead is</strong></em>:</p><br /><ul><br /><li>Often the day-to-day primary point of contact with our clients</li><br /><li>Able to strategically lead a project team to successful delivery</li><br /><li>Excited to mentor, influence and lead a team of ThoughtWorkers and clients</li><br /><li>An expert in at least one language or domain, and maybe in 2 or more</li><br /></ul>",
                     published: '2016-01-30 21:09:39 UTC' }

  let(:subject){ JobFetcher }

  describe '.create_records' do
    let(:action){ subject.create_records(sample_raw_entry) }

    context 'when no matching company record exists' do
      it 'creates a company record' do
        expect{ action }.to change{ Company.count }.from(0).to(1)
      end

      it 'sets the name on company record' do
        action
        expect(Company.last.name).to eq(sample_raw_entry[:company_name])
      end

      it 'does assigns a job to existing company' do
      end
    end

    context 'with an existing company' do
      let(:company_name){ "thoughtworks" }
      let!(:company){ create(:company, name: company_name) }

      it 'does not create another company' do
        expect{ action }.to_not change{ Company.count }
      end

      it 'does assigns a job to existing company' do
      end
    end
  end
end
