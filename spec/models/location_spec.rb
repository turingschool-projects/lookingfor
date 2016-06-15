require 'rails_helper'

RSpec.describe Location, type: :model do
  it "has a valid factory" do
    expect(build(:location)).to be_valid
  end

  let(:instance) { build(:location) }
  describe "Validations" do
    it { expect(instance).to validate_presence_of(:name) }
    it { expect(instance).to validate_uniqueness_of(:name) }
  end

  describe "Associations" do
    it { expect(instance).to have_many(:jobs) }
  end

end
