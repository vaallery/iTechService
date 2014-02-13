class CreateSpareParts < ActiveRecord::Migration
  def change
    create_table :spare_parts do |t|
      t.references :repair_service
      t.references :product
      t.integer :quantity
      t.integer :warranty_term

      t.timestamps
    end
    add_index :spare_parts, :repair_service_id
    add_index :spare_parts, :product_id
  end
end
