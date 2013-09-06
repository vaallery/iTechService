class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.references :product_group

      t.timestamps
    end
    add_index :products, :product_group_id
  end
end
