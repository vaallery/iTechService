class CreateTopSalables < ActiveRecord::Migration
  def change
    create_table :top_salables do |t|
      t.references :product
      t.string :name
      t.string :ancestry
      t.integer :position
      t.string :color

      t.timestamps
    end
    add_index :top_salables, :ancestry
    add_index :top_salables, :product_id
  end
end
