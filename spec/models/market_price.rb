require 'rails_helper'

RSpec.describe MarketPrice, type: :model do
  describe "associations" do
    it { should have_many(:stocks).dependent(:delete_all) }
    it { should have_many(:bearers).through(:stocks) }
  end

  describe "validations" do
    subject { FactoryBot.create(:market_price) }

    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:value_cents) }

    it { should validate_length_of(:currency) }

    it { should validate_uniqueness_of(:currency).scoped_to(:value_cents).with_message('combination with value_cents should be uniq') }
  end
end
