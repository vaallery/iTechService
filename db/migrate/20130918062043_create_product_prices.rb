class CreateProductPrices < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.references :product
      t.references :price_type
      t.date :date
      t.decimal :value

      t.timestamps
    end
    add_index :product_prices, :product_id
    add_index :product_prices, :price_type_id
  end
end
