class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :code
      t.belongs_to :group
      t.belongs_to :category
      t.boolean :is_service
      t.boolean :request_price

      t.timestamps
    end
    add_index :products, :group_id
    add_index :products, :category_id
    add_index :products, :code
  end
end
