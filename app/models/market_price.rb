# == Schema Information
#
# Table name: market_prices
#
#  id          :integer          not null, primary key
#  currency    :string           not null
#  value_cents :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MarketPrice < ApplicationRecord
  has_many :stocks
  has_many :bearers, through: :stocks

  validates :currency, uniqueness: { scope: :value_cents, message: "combination with ValueCents for MarketPrice should be uniq" }
  validates :currency, length: { maximum: 255, message: "for MarketPrice is too long. Maximum 255 chars" }
end

