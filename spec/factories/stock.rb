FactoryGirl.define do
  factory :stock do

    name "New Stock"
    bearer { build(:bearer) }
    market_price { build(:market_price) }

  end

  factory :stock_2, class: Stock do

    name "Stock 2"
    bearer { build(:bearer) }
    market_price { build(:market_price) }

  end
end
