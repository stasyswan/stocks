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
  has_many :stocks, dependent: :delete_all
  has_many :market_prices, through: :stocks

  validates :name, presence: { message: "can't be blank" }
  validates :name, uniqueness: { message: "has already been taken" }
  validates :name, length: { maximum: 255, message: "is too long. Maximum 255 chars" }
end
