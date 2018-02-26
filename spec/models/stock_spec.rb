require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "associations" do
    it { should belong_to(:bearer) }
    it { should belong_to(:market_price) }
  end

  describe "validations" do
    subject { FactoryBot.create(:stock) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should_not allow_value("invalid").for(:name) }
  end
end
