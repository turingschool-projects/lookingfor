require 'rails_helper'

describe Job do
  it "has a valid factory" do
    expect(build(:job)).to be_valid
  end

  before(:all) do
  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.add_stub(
  "1510 Blake Street Denver CO", [
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

  let(:instance) { build(:job) }

  describe "Validations" do
    it { expect(instance).to validate_presence_of(:title) }
    it { expect(instance).to validate_uniqueness_of(:title) }
    it { expect(instance).to allow_value(['ruby', 'go']).for(:raw_technologies) }
  end

  describe "Associations" do
    it { expect(instance).to belong_to(:company) }
    it { expect(instance).to have_and_belong_to_many(:technologies) }
  end

  describe "Callbacks" do
    it 'downcases raw_technologies' do
      object = create(:job, raw_technologies: ['Ruby', 'Go'])
      expect(object.raw_technologies).to match(['ruby', 'go'])
    end
  end

  describe '#assign_tech' do
    it 'assignes any technologies that match raw tech' do
      existing_tech = create(:technology, name: 'ruby')
      object = create(:job, raw_technologies: ['ruby', 'java'])
      object.assign_tech
      expect(Job.last.technologies.count).to eq(1)
      expect(Job.last.technologies.first).to eq(existing_tech)
    end

    context 'when no matches exist' do
      it 'assigns no technologies' do
        existing_tech = create(:technology, name: 'ruby')
        object = create(:job, raw_technologies: ['java'])
        object.assign_tech
        expect(object.technologies.count).to eq(0)
      end
    end
  end

  describe 'geocodes' do
    it 'uses geocoder to fetch lat and long coordinates' do
      job = Job.create(location: "1510 Blake Street Denver CO")
      coords = Geocoder.search(job.location).first.data

      expect(coords['latitude']).to eq(40.7143528)
      expect(coords['longitude']).to eq(-74.0059731)
    end
  end
end
