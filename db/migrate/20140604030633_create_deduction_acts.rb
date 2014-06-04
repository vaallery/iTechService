class CreateDeductionActs < ActiveRecord::Migration
  def change
    create_table :deduction_acts do |t|
      t.integer :status, null: false, default: 0
      t.datetime :date
      t.references :store
      t.references :user
      t.text :comment

      t.timestamps
    end
    add_index :deduction_acts, :store_id
    add_index :deduction_acts, :user_id
  end
end
