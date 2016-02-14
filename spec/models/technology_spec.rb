require 'rails_helper'

describe Technology do
  it "has a valid factory" do
    expect(build(:technology)).to be_valid
  end

  let(:instance) { build(:technology) }

  describe "Validations" do
    it { expect(instance).to validate_presence_of(:name) }
  end
end
