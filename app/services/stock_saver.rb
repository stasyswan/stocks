# frozen_string_literal: true

class StockSaver

  def initialize(params)
    @name = params[:name]
    @bearer_attributes = params[:bearer_attributes]
    @market_price_attributes = params[:market_price_attributes]
  end

  def self.run(stock, params)
    new(params).run(stock)
  end

  def run(stock)
    ActiveRecord::Base.transaction do
      stock.update_attributes!(name: name, bearer: bearer, market_price: market_price)
    end
  end

  def bearer
    Bearer.where(name: bearer_attributes[:name]).first_or_create!(bearer_attributes)
  end

  def market_price
    MarketPrice
      .where(currency: market_price_attributes[:currency], value_cents: market_price_attributes[:value_cents])
      .first_or_create!(market_price_attributes)
  end

  private

  attr_reader :name, :bearer_attributes, :market_price_attributes

end

