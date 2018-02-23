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
  has_many :stocks, dependent: :delete_all
  has_many :bearers, through: :stocks

  validates :currency, presence: { message: "can't be blank" }
  validates :value_cents, presence: { message: "can't be blank" }
  validates :currency, uniqueness: { scope: :value_cents, message: "combination with value_cents should be uniq" }
  validates :currency, length: { maximum: 255, message: "is too long. Maximum 255 chars" }
end

