class CreateDeductionItems < ActiveRecord::Migration
  def change
    create_table :deduction_items do |t|
      t.references :item, null: false
      t.references :deduction_act
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
    add_index :deduction_items, :item_id
    add_index :deduction_items, :deduction_act_id
  end
end
