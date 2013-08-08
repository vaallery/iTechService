class CreateInstallmentPlans < ActiveRecord::Migration
  def change
    create_table :installment_plans do |t|
      t.references :user, null: false
      t.string :object
      t.integer :cost
      t.date :issued_at

      t.timestamps
    end
    add_index :installment_plans, :user_id
  end
end
