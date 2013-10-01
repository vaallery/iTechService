class CreatePriceTypes < ActiveRecord::Migration
  def change
    create_table :price_types do |t|
      t.string :name
      t.integer :kind

      t.timestamps
    end
    add_index :price_types, :kind
  end
end
