class CreateMediaMenuCartItems < ActiveRecord::Migration
  def change
    create_table :media_menu_cart_items do |t|
      t.integer :item_id

      t.timestamps null: false
    end
  end
end
