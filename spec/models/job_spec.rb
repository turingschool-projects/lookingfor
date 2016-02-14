require 'rails_helper'

describe Job do
  it "has a valid factory" do
    expect(build(:job)).to be_valid
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
end
