# == Schema Information
#
# Table name: bearers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bearer < ApplicationRecord
  has_many :stocks
  has_many :market_prices, through: :stocks

  validates :name, presence: { message: "for Bearer can't be empty" }
  validates :name, uniqueness: { message: "for Bearer has already been taken" }
  validates :name, length: { maximum: 255, message: "for Bearer is too long. Maximum 255 chars" }
end
