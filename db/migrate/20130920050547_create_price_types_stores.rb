class CreatePriceTypesStores < ActiveRecord::Migration
  def change
    create_table :price_types_stores do |t|
      t.references :price_type
      t.references :store
    end
    add_index :price_types_stores, :price_type_id
    add_index :price_types_stores, :store_id
  end
end
