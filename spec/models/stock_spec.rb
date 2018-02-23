require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "associations" do
    it { should belong_to(:bearer) }
    it { should belong_to(:market_price) }
  end

  describe "validations" do
    subject { FactoryBot.create(:stock) }

    it { should validate_presence_of(:name).with_message("can't be blank") }
    it { should validate_length_of(:name).with_message('is too long. Maximum 255 chars') }
    it { should validate_uniqueness_of(:name).with_message("has already been taken") }
    it { should_not allow_value("invalid").for(:name) }
  end
end
