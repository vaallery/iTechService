class CreateOrderNotes < ActiveRecord::Migration
  def change
    create_table :order_notes do |t|
      t.references :order, null: false, index: true, foreign_key: true
      t.references :author, null: false, index: true
      t.text :content, null: false

      t.timestamps null: false
    end

    add_foreign_key :order_notes, :users, column: :author_id
  end
end
