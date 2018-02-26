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

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 }
end
