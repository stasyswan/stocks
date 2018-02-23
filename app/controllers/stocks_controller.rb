class StocksController < ApplicationController
  before_action :set_stock, only: [:update, :destroy]

  def index
    @stocks = Stock.active.includes(:bearer).includes(:market_price).to_json(include: [:bearer, :market_price])

    json_response @stocks
  end

  def create
    @stock = Stock.create! stock_params

    json_response @stock
  end

  def update
    @stock_saver = StockSaver.new stock_params.merge(id: params[:id])
    @stock_saver.update @stock

    json_response @stock_saver
  end

  def destroy
    @stock.update_attribute :removed, true

    json_response @stock
  end

  private

  def stock_params
    params.require(:stock).permit(:name,
                                  bearer_attributes: [:name],
                                  market_price_attributes: [:currency, :value_cents])
  end

  def set_stock
    @stock = Stock.find_by_id_and_removed! params[:id], false
  end
end
