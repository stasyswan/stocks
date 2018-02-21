class StockSaver
  include ActiveModel::Model

  attr_accessor :id, :name, :bearer, :market_price

  def create
    raise ActiveRecord::StatementInvalid if invalid?

    ActiveRecord::Base.transaction do
      new_bearer = Bearer.create!(bearer)
      new_market_price = MarketPrice.create!(market_price)

      Stock.create!(name: name, bearer: new_bearer, market_price: new_market_price)
    end
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
  end

  def update
    raise ActiveRecord::StatementInvalid if invalid?

    ActiveRecord::Base.transaction do
      get_bearer = Bearer.where(name: bearer[:name]).first_or_create!(bearer)

      get_market_price = MarketPrice.where(currency: market_price[:currency], value_cents: market_price[:value_cents])
                         .first_or_create!(market_price)

      Stock.find(id).update_attributes!(name: name, bearer: get_bearer, market_price: get_market_price)
    end
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
  end
end