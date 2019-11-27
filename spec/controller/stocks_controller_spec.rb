# frozen_string_literal: true

require 'rails_helper'

describe StocksController, type: :controller do
  before { request.headers['Content-Type'] = 'application/json' }

  describe 'GET /stocks' do
    let!(:stock) { create(:stock) }
    let!(:stock_2) { create(:stock_2) }
    let(:stock_deleted) { create(:stock_deleted) }

    before { get :index }

    it 'returns list with stocks' do
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(2)
      expect(response.body).to eq([stock, stock_2].to_json(include: %i[bearer market_price]))
    end
  end

  describe 'POST /stocks' do
    context 'with valid data' do
      let(:params) do
        {
          stock: {
            name: 'Valid stock',
            bearer_attributes: FactoryBot.attributes_for(:bearer),
            market_price_attributes: FactoryBot.attributes_for(:market_price)
          }
        }
      end

      before { post :create, params: params }

      it 'returns stock and 200 OK' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(Stock.last.to_json)

        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(1)
        expect(MarketPrice.count).to eq(1)
      end
    end

    context 'with invalid data' do
      let(:params) do
        {
          name: 'invalid',
          bearer: 'invalid',
          value: 19.39,
          currency: 'EUR'
        }
      end

      before { post :create, params: params }

      it 'returns 422 and fail to save' do
        expect(response).to have_http_status(:unprocessable_entity)

        expect(json).to eq({ 'error' => { 'bearer' => ['is invalid'],
                                          'market_price' => ['is invalid'],
                                          'name' => ['is invalid'] } })

        expect(Stock.count).to eq(0)
        expect(Bearer.count).to eq(0)
        expect(MarketPrice.count).to eq(0)
      end
    end
  end

  describe 'PATCH /stocks/:id' do
    context 'with different bearer' do
      let(:stock) { create(:stock) }

      let(:params) do
        {
          id: stock.id,
          stock: {
            name: 'Valid stock',
            bearer_attributes: FactoryBot.attributes_for(:bearer_2),
            market_price_attributes: FactoryBot.attributes_for(:market_price)
          }
        }
      end

      before { patch :update, params: params }

      it 'creates new bearer but keep market price' do
        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(2)
        expect(MarketPrice.count).to eq(1)

        expect(json['name']).to eq('Valid stock')
        expect(json['bearer_attributes']['name']).to eq('Me 2')
        expect(json['market_price_attributes']['currency']).to eq('EUR')
        expect(json['market_price_attributes']['value_cents']).to eq(19.39)
      end
    end

    context 'with different market price' do
      let(:stock) { create(:stock) }

      let(:params) do
        {
          id: stock.id,
          stock: {
            name: 'Valid stock',
            bearer_attributes: FactoryBot.attributes_for(:bearer),
            market_price_attributes: FactoryBot.attributes_for(:market_price_2)
          }
        }
      end

      before { patch :update, params: params }

      it 'creates new market price but keep bearer' do
        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(1)
        expect(MarketPrice.count).to eq(2)

        expect(json['name']).to eq('Valid stock')
        expect(json['bearer_attributes']['name']).to eq('Me')
        expect(json['market_price_attributes']['currency']).to eq('$')
        expect(json['market_price_attributes']['value_cents']).to eq(53.29)
      end
    end

    context 'with existing bearer and market price' do
      let(:stock) { create(:stock) }

      let(:params) do
        {
          id: stock.id,
          stock: {
            name: 'Valid stock',
            bearer_attributes: FactoryBot.attributes_for(:bearer),
            market_price_attributes: FactoryBot.attributes_for(:market_price)
          }
        }
      end

      before { patch :update, params: params }

      it 'references existing bearer and market price to stock' do
        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(1)
        expect(MarketPrice.count).to eq(1)

        expect(json['name']).to eq('Valid stock')
        expect(json['bearer_attributes']['name']).to eq('Me')
        expect(json['market_price_attributes']['currency']).to eq('EUR')
        expect(json['market_price_attributes']['value_cents']).to eq(19.39)
      end
    end

    context 'when unexisted record' do
      let(:params) do
        {
          id: 1,
          stock: {
            name: 'Valid stock',
            bearer_attributes: FactoryBot.attributes_for(:bearer),
            market_price_attributes: FactoryBot.attributes_for(:market_price)
          }
        }
      end

      before { patch :update, params: params }

      it 'returns 404 and fail to save' do
        expect(json['error']).to eq("Couldn't find Stock with id: #{params[:id]}")
      end
    end

    context 'when deleted record' do
      let(:stock_deleted) { create(:stock_deleted) }

      let(:params) do
        {
          id: stock_deleted.id,
          stock: {
            name: 'Valid stock',
            bearer_attributes: FactoryBot.attributes_for(:bearer),
            market_price_attributes: FactoryBot.attributes_for(:market_price)
          }
        }
      end

      before { patch :update, params: params }

      it 'returns 404 and fail to save' do
        expect(json['error']).to eq("Couldn't find Stock with id: #{params[:id]}")
      end
    end
  end

  describe 'DELETE /stocks/:id' do
    context 'with valid data' do
      let(:stock) { create(:stock) }

      before { delete :destroy, params: { id: stock.id } }

      it 'soft-deletes a stock' do
        expect(json['removed']).to be true
      end
    end

    context 'when unexisted record' do
      let(:params) { { id: 1 } }

      before { delete :destroy, params: params }

      it 'returns 404 and fail to save' do
        expect(json['error']).to eq("Couldn't find Stock with id: #{params[:id]}")
      end
    end

    context 'when deleted record' do
      let(:params) { { id: 1 } }
      let(:stock_deleted) { create(:stock_deleted) }

      before { delete :destroy, params: params }

      it 'returns 404 and fail to save' do
        expect(json['error']).to eq("Couldn't find Stock with id: #{params[:id]}")
      end
    end
  end
end

