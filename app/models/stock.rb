# frozen_string_literal: true

# == Schema Information
#
# Table name: stocks
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  bearer_id       :integer          not null
#  market_price_id :integer          not null
#  removed         :boolean          default('f')
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Stock < ApplicationRecord

  belongs_to :market_price, optional: true
  belongs_to :bearer, optional: true

  validates :bearer, :market_price, presence: { message: 'is invalid' }

  validates :name,
            presence: true,
            uniqueness: true,
            format: { without: /invalid/, message: 'is invalid' },
            length: { maximum: 255 }

  scope :active, -> { where(removed: false) }

  accepts_nested_attributes_for :bearer, :market_price

end

