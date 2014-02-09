class CreateSpairParts < ActiveRecord::Migration
  def change
    create_table :spair_parts do |t|
      t.references :repair_service
      t.references :product
      t.integer :quantity
      t.integer :warranty_term

      t.timestamps
    end
    add_index :spair_parts, :repair_service_id
    add_index :spair_parts, :product_id
  end
end
