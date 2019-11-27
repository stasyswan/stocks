# frozen_string_literal: true

FactoryBot.define do
  factory :stock do
    name { 'New Stock' }
    bearer { build(:bearer) }
    market_price { build(:market_price) }
  end

  factory :stock_2, class: 'Stock' do
    name { 'Stock 2' }
    bearer { build(:bearer_2) }
    market_price { build(:market_price_2) }
  end

  factory :stock_deleted, class: 'Stock' do
    name { 'Stock Deleted' }
    bearer { build(:bearer_3) }
    market_price { build(:market_price_3) }
    removed { true }
  end
end

