require 'rails_helper'

describe Technology do
  it "has a valid factory" do
    expect(build(:technology)).to be_valid
  end

  let(:instance) { build(:technology) }

  describe "Validations" do
    it { expect(instance).to validate_presence_of(:name) }
    it { expect(instance).to validate_uniqueness_of(:name) }
  end

  describe "Associations" do
    it { expect(instance).to have_and_belong_to_many(:jobs) }
  end

  describe "Callbacks" do
    it 'downcases itself before saving' do
      object = create(:technology, name: 'Ruby')
      expect(object.name).to eq('ruby')
    end
  end
end
