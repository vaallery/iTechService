class CreateProductRelations < ActiveRecord::Migration
  def change
    create_table :product_relations do |t|
      t.references :parent, polymorphic: true
      t.references :relatable, polymorphic: true
      t.timestamps
    end
    add_index :product_relations, [:parent_type, :parent_id]
    add_index :product_relations, [:relatable_type, :relatable_id]
  end
end
