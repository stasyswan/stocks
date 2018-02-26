require 'rails_helper'

RSpec.describe Bearer, type: :model do
  describe "associations" do
    it { should have_many(:stocks).dependent(:delete_all) }
    it { should have_many(:market_prices).through(:stocks) }
  end

  describe "validations" do
    subject { FactoryBot.create(:bearer) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
