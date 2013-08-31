class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.belongs_to :category
      t.string :ancestry

      t.timestamps
    end
    add_index :products, :category_id
    add_index :products, :code
    add_index :products, :ancestry
  end
end
