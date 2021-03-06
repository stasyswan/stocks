# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:bearer) }
    it { is_expected.to belong_to(:market_price) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:stock) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.not_to allow_value('invalid').for(:name) }
  end
end

