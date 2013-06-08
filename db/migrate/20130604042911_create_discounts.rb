class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :value
      t.integer :limit

      t.timestamps
    end
    add_index :discounts, :limit
  end
end
