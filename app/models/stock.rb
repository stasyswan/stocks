# == Schema Information
#
# Table name: stocks
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  bearer_id       :integer          not null
#  market_price_id :integer          not null
#  removed         :boolean          default("f")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Stock < ApplicationRecord
  belongs_to :market_price
  belongs_to :bearer

  validates :name, presence: { message: "for Stock can't be empty" }
  validates :name, uniqueness: { message: "for Stock has already been taken" }
  validates :name, length: { maximum: 255, message: "for Stock is too long. Maximum 255 chars" }

  scope :active, -> { where(removed: false) }
end
