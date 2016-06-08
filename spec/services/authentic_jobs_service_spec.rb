require 'rails_helper'

describe AuthenticJobsService do
  let(:service) { AuthenticJobsService }

  before(:all) do
  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.add_stub(
  "Portland, OR", [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
     }
    ]
   )
  Geocoder::Lookup::Test.add_stub(
  "Philadelphia, PA", [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
     }
    ]
   )
  Geocoder::Lookup::Test.add_stub(
  "Portland Oregon", [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
     }
    ]
   )
  Geocoder::Lookup::Test.add_stub(
  "Remote", [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
     }
    ]
   )
  end

  describe '.scrape' do
    let(:term){ 'ruby' }
    let(:action){ service.scrape(term) }
    let!(:technology){ create(:technology, name: term) }

    before :each do
      # action
    end

    it 'it should set technology on all records' do
      jobs_without_tech = Job.includes(:jobs_technologies)
        .where(jobs_technologies: { technology_id: nil}).count
      expect(jobs_without_tech).to eq(0)
    end
  end

  describe '.scrape no results' do
    let(:term){ 'rubular' }
    let(:action){ service.scrape(term) }

    before :each do
      # stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=Portland%20Oregon&language=en&sensor=false").
      #     with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      #     to_return(:status => 200, :body => "", :headers => {})
      #
      action
    end

    it 'should not create any jobs from zero results' do
      expect(Job.count).to eq 0
    end
  end

  describe 'bad api key response' do
    it 'should return no listings' do
      connection = service.initial_connection
      response = connection.get("?api_key=123&keywords=javascript")

      expect(response[:listings]).to be_nil
    end
  end

  describe '.pull_location' do
    it 'returns location for a posting' do
      entry = service.get_jobs('ruby')[2]
      location = service.pull_location(entry)
      expect(location).to eq("Denver, CO, US")
    end

    it 'returns remote for telecommuting job with no location' do
      entry = service.get_jobs('ruby')[0]
      location = service.pull_location(entry)
      expect(location).to eq("Remote")
    end
  end

  describe '.pull_technologies' do
    let(:job_fetcher) { JobFetcher }

    before(:each) do
      allow(job_fetcher).to receive(:technologies).and_return(['python', 'go', 'ruby', 'elixir'])
    end

    it 'should return an array of technologies' do
      description = "You should know ruby and python!"
      term = 'ruby'
      tech = service.pull_technologies(description, term)
      expect(tech).to eq ['python', 'ruby']
    end

    it 'should return the tech search term if no tech found in description' do
      description = "You should know a scripting language."
      term = 'ruby'
      tech = service.pull_technologies(description, term)
      expect(tech).to eq ['ruby']
    end
  end

  describe '.format_entry' do
    it 'should return a hash with info to be sent to job fetcher' do
      term = 'ruby'
      entry = service.get_jobs(term)[2]

      formatted_entry = { job: {
          title: "Web Developer at Chalk (Denver, CO, US)",
          url: "https://authenticjobs.com/jobs/27094/web-developer",
          location: "Denver, CO, US",
          raw_technologies: ['ruby'],
          description: "<p><p>We’re a two person partnership located in the oh-so-hip RiNo area of Denver, where we’ve been quietly creating usable and maintainable interactive solutions for our clients. If you’ve ever wanted to be that guy or gal people at the office point at in awe, while uttering the magical phrase, “that's employee number one” - this job’s for you.</p><p>We’re looking for a front-end developer that can make our designs a reality. Under the tutelage of our senior developer, you will use HTML, CSS and Javascript to take a project from hi-fi comps to a fully functioning solution.</p><p>While we’re sure you’re a simply lovely person, <strong>we need to make sure you have a few qualifications first</strong>:</p><ul><li>1+ years development experience.</li><li>Knowledge of standards-compliant HTML5 and CSS3, including responsive design techniques.</li><li>Some familiarity with JavaScript and a smattering of libraries - e.g., jQuery or Underscore/LoDash, etc.</li><li>Familiarity with version control tools (we use Git).</li><li>Ability to perform QA on a myriad of devices with differing screen sizes and resolutions.</li><li>Interest in your career as a craft - this includes researching new technologies, and perfecting your use of current ones.</li><li>Ability to communicate well with both internal team members and external stakeholders.</li></ul><p>That’s the gist of things, <strong>but the following certainly wouldn’t hurt</strong>:</p><ul><li>Familiarity with some server-side technologies. PHP and/or Ruby comes to mind.</li><li>Familiarity with Sketch and/or Photoshop.</li><li>Familiarity with CMS platforms (e.g., Wordpress).</li><li>Familiarity with SEO techniques.</li></ul><p>We have a flexible work schedule, will provide you with a shiny new Macbook Pro and some pretty posh digs for you to do your thing. If this sounds like your jam, send over your resumé and, (if you have one) your github username. The location of any past projects you worked on would be helpful as well. </p><p>We’re looking forward to working together!</p></p>",
          remote: false,
          posted_date: "2016-04-06 18:51:33"
        },
        company: {
          name: "Chalk"
        }
      }

      expect(service.format_entry(entry, term)).to eq formatted_entry
    end
  end

  describe '.pull_company_name' do
    it 'should return company name' do
      entry = {company: {name: "Turing"}}
      company_name = service.pull_company_name(entry)

      expect(company_name).to eq "Turing"
    end

    it 'should return empty string if no company info' do
      entry = {}
      company_name = service.pull_company_name(entry)

      expect(company_name).to eq ""
    end
  end

  describe '.full_title' do
    it 'should return a title with the company name and location' do
      entry = {title: "Web Developer", company: {name: "Turing", location: {name: "Denver, CO"}}}
      company_name = service.full_title(entry)

      expect(company_name).to eq "Web Developer at Turing (Denver, CO)"
    end
  end
end
