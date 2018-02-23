class StockSaver
  include ActiveModel::Model

  attr_accessor :id, :name, :bearer_attributes, :market_price_attributes

  def update stock
    ActiveRecord::Base.transaction do
      get_bearer = Bearer.where(name: bearer_attributes[:name])
                       .first_or_create!(bearer_attributes)

      get_market_price = MarketPrice.where(currency: market_price_attributes[:currency],
                                           value_cents: market_price_attributes[:value_cents])
                             .first_or_create!(market_price_attributes)

      stock.update_attributes!(name: name,
                              bearer: get_bearer,
                              market_price: get_market_price)
    end
  end
end