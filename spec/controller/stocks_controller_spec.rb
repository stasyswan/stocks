require "rails_helper"

RSpec.describe StocksController, type: :controller do

  before :each do
    request.headers["Content-Type"] = 'application/json'
  end

  describe "GET /stocks/" do
    let!(:stock){ create(:stock) }
    let!(:stock_2){ create(:stock_2) }
    let!(:stock_deleted){ create(:stock_deleted) }

    before { get :index }

    it "should return list with stocks" do
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(2)
      expect(response.body).to eq([stock, stock_2].to_json(include: [:bearer, :market_price]))
    end
  end

  describe "POST /stocks/" do
    context "with valid data" do

      params = { stock: { name: "Valid stock",
                          bearer_attributes: FactoryBot.attributes_for(:bearer),
                          market_price_attributes: FactoryBot.attributes_for(:market_price) }}

      before { post :create, params: params }

      it "should return stock and 200 OK" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(Stock.last.to_json)

        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(1)
        expect(MarketPrice.count).to eq(1)
      end
    end

    context "with invalid data" do
      it "should return 422 and fail to save" do

        params = { stock: {
            name: "invalid",
            bearer: "invalid",
            value: 19.39,
            currency: "EUR" }}

        post :create, params: params

        expect(response).to have_http_status(422)

        expect(json).to eq({"error"=>{"bearer"=>["is invalid"],
                                      "market_price"=>["is invalid"],
                                      "name"=>["is invalid"]}})

        expect(Stock.count).to eq(0)
        expect(Bearer.count).to eq(0)
        expect(MarketPrice.count).to eq(0)

      end
    end
  end

  describe "PATCH /stocks/:id" do
    context "with different bearer" do
      let!(:stock){ create(:stock) }

      params = { id: 1,
                 stock: { name: "Valid stock",
                          bearer_attributes: FactoryBot.attributes_for(:bearer_2),
                          market_price_attributes: FactoryBot.attributes_for(:market_price) }}
      before { patch :update, params: params }

      it "should create new bearer but keep market price" do
        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(2)
        expect(MarketPrice.count).to eq(1)

        expect(json["name"]).to eq("Valid stock")
        expect(json["bearer_attributes"]["name"]).to eq("Me 2")
        expect(json["market_price_attributes"]["currency"]).to eq("EUR")
        expect(json["market_price_attributes"]["value_cents"]).to eq(19.39)
      end
    end

    context "with different market price" do
      let!(:stock){ create(:stock) }

      params = { id: 1,
                 stock: { name: "Valid stock",
                          bearer_attributes: FactoryBot.attributes_for(:bearer),
                          market_price_attributes: FactoryBot.attributes_for(:market_price_2) }}

      before { patch :update, params: params }

      it "should create new market price but keep bearer" do
        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(1)
        expect(MarketPrice.count).to eq(2)

        expect(json["name"]).to eq("Valid stock")
        expect(json["bearer_attributes"]["name"]).to eq("Me")
        expect(json["market_price_attributes"]["currency"]).to eq("$")
        expect(json["market_price_attributes"]["value_cents"]).to eq(53.29)
      end
    end

    context "with existing bearer and market price" do
      let!(:stock){ create(:stock) }

      params = { id: 1,
                 stock: { name: "Valid stock",
                          bearer_attributes: FactoryBot.attributes_for(:bearer),
                          market_price_attributes: FactoryBot.attributes_for(:market_price) }}

      before { patch :update, params: params }

      it "should reference existing bearer and market price to stock" do
        expect(Stock.count).to eq(1)
        expect(Bearer.count).to eq(1)
        expect(MarketPrice.count).to eq(1)

        expect(json["name"]).to eq("Valid stock")
        expect(json["bearer_attributes"]["name"]).to eq("Me")
        expect(json["market_price_attributes"]["currency"]).to eq("EUR")
        expect(json["market_price_attributes"]["value_cents"]).to eq(19.39)
      end
    end

    context "unexisted record" do

      params = { id: 1,
                 stock: { name: "Valid stock",
                          bearer_attributes: FactoryBot.attributes_for(:bearer),
                          market_price_attributes: FactoryBot.attributes_for(:market_price) }}

      before { patch :update, params: params }

      it "should return 404 and fail to save" do
        expect(json["error"]).to eq("Couldn't find Stock with id: 1")
      end
    end

    context "deleted record" do
      let!(:stock_deleted){ create(:stock_deleted) }

      params = { id: 1,
                 stock: { name: "Valid stock",
                          bearer_attributes: FactoryBot.attributes_for(:bearer),
                          market_price_attributes: FactoryBot.attributes_for(:market_price) }}

      before { patch :update, params: params }

      it "should return 404 and fail to save" do
        expect(json["error"]).to eq("Couldn't find Stock with id: 1")
      end
    end
  end

  describe "DELETE /stocks/:id" do
    context "with valid data" do
      let!(:stock){ create(:stock) }

      before { delete :destroy, params: { id: 1 }}

      it "should soft-delete a stock" do
        expect(json["removed"]).to be true
      end
    end

    context "unexisted record" do
      before { delete :destroy, params: { id: 1 }}

      it "should return 404 and fail to save" do
        expect(json["error"]).to eq("Couldn't find Stock with id: 1")
      end
    end

    context "deleted record" do
      let!(:stock_deleted){ create(:stock_deleted) }

      before { delete :destroy, params: { id: 1 }}

      it "should return 404 and fail to save" do
        expect(json["error"]).to eq("Couldn't find Stock with id: 1")
      end
    end
  end
end
