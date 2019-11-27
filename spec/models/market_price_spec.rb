# frozen_string_literal: true

require 'rails_helper'

describe MarketPrice, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:stocks).dependent(:delete_all) }
    it { is_expected.to have_many(:bearers).through(:stocks) }
  end

  describe 'validations' do
    subject(:market_price) { FactoryBot.create(:market_price) }

    it { is_expected.to validate_presence_of(:currency) }
    it { is_expected.to validate_presence_of(:value_cents) }
    it { is_expected.to validate_length_of(:currency) }

    it 'validates uniqueness of currency' do
      expect(market_price)
        .to(
          validate_uniqueness_of(:currency)
            .scoped_to(:value_cents)
            .with_message('combination with value_cents should be uniq')
        )
    end
  end
end

