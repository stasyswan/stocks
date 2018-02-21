class StocksController < ApplicationController

  def index
    @stocks = Stock.active.includes(:bearer).includes(:market_price).to_json(include: [:bearer, :market_price])

    json_response(@stocks)
  end

  def create
    @stock = StockSaver.new(stock_params)
    @stock.create

    json_response(@stock, :created)
  end

  def update
    @stock = StockSaver.new(stock_params.merge(id: params[:id]))
    @stock.update

    json_response(@stock)
  end

  def destroy
    @stock = Stock.find(params[:id])
    @stock.update_attribute(:removed, true)

    json_response(@stock)
  end

  private

  def stock_params
    params.require(:stock).permit(:name, bearer: [:name], market_price: [:currency, :value_cents])
  end
end
