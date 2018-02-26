class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.string :name, null: false
      t.references :bearer, null: false
      t.references :market_price, null: false
      t.boolean :removed, default: false
      t.timestamps

      t.index :name, unique: true
    end
  end
end
