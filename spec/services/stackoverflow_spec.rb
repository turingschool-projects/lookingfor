require 'rails_helper'

describe StackOverflow do
  let(:service){ StackOverflow.new('ruby') }

  before(:all) do
  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.add_stub(
  "London, UK", [
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
  "New York, NY", [
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
  "San Francisco, CA", [
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
  "Denver, CO", [
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
  "Boston, MA", [
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
  "Chicago, IL", [
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
  "Munich, Germany", [
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
  "Campbell, CA", [
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
  "Ridge, NY", [
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
  "Washington, DC", [
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
  "Glen Allen, VA", [
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
  "Madison, WI", [
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
  "Minneapolis, MN", [
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
  "Los Angeles, CA", [
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
  "Needham, MA", [
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
  "Amsterdam, Netherlands", [
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
  "Palo Alto, CA", [
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
  "Vancouver, BC, Canada", [
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
    let(:action){ service.scrape }
    let!(:technology){ create(:technology, name: term) }

    before :each do
      # binding.pry
      # action
    end

    it 'it should set technology on all records' do
      jobs_without_tech = Job.includes(:jobs_technologies)
        .where(jobs_technologies: { technology_id: nil}).count
      expect(jobs_without_tech).to eq(0)
    end
  end

  describe '.pull_company_name' do
    it 'pulls a company from a title' do
      title = "Principal Software Engineer at Comcast (Philadelphia, PA)"
      company_name = service.pull_company_name(title)
      expect(company_name).to eq('Comcast')
    end

    it 'handles unmatching pattern' do
      title = "Principal Software Engineer Comcast (Philadelphia, PA)"
      company_name = service.pull_company_name(title)
      expect(company_name).to eq('')
    end
  end

  describe '.pull_location' do
    it 'pulls a location from a title' do
      title = "Principal Software Engineer at Comcast (Philadelphia, PA)"
      company_name = service.pull_location(title)
      expect(company_name).to eq('Philadelphia, PA')
    end

    it 'handles unmatching pattern' do
      title = "Principal Software Engineer at Comcast"
      company_name = service.pull_location(title)
      expect(company_name).to eq('')
    end
  end

  describe '.is_remote?' do
    context 'when title contains remote' do
      it 'returns true' do
        title = 'remote job'
        expect(service.is_remote?(title)).to be true
      end
    end
    context 'when title does not contain' do
      it 'returns false' do
        title = 'in Southern California'
        expect(service.is_remote?(title)).to be false
      end
    end
    context 'when title is nil' do
      it 'returns false' do
        title = nil
        expect(service.is_remote?(title)).to be false
      end
    end
  end
end
