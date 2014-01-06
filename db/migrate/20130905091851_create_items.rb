class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :product

      t.timestamps
    end
    add_index :items, :product_id
  end
end
