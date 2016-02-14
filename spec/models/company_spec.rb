require 'rails_helper'

describe Company do
  it "has a valid factory" do
    expect(build(:company)).to be_valid
  end

  let(:instance) { build(:company) }

  describe "Validations" do
    it { expect(instance).to validate_presence_of(:name) }
    it { expect(instance).to validate_uniqueness_of(:name) }
  end

  describe "Associations" do
    it { expect(instance).to have_many(:jobs).dependent(:destroy) }
  end
end
