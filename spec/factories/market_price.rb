# frozen_string_literal: true

FactoryBot.define do
  factory :market_price do
    value_cents { 19.39 }
    currency { 'EUR' }
  end

  factory :market_price_2, class: 'MarketPrice' do
    value_cents { 53.29 }
    currency { '$' }
  end

  factory :market_price_3, class: 'MarketPrice' do
    value_cents { 158.20 }
    currency { '$' }
  end
end

