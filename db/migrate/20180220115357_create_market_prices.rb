class CreateMarketPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :market_prices do |t|
      t.string :currency, null: false
      t.integer :value_cents, null: false
      t.timestamps

      t.index [:currency, :value_cents], unique: true
    end
  end
end
