require 'rails_helper'

RSpec.describe Bearer, type: :model do
  describe "associations" do
    it { should have_many(:stocks).dependent(:delete_all) }
    it { should have_many(:market_prices).through(:stocks) }
  end

  describe "validations" do
    subject { FactoryBot.create(:bearer) }

    it { should validate_presence_of(:name).with_message("can't be blank") }
    it { should validate_length_of(:name).with_message('is too long. Maximum 255 chars') }
    it { should validate_uniqueness_of(:name).with_message('has already been taken') }
  end
end
