class CreateInstallments < ActiveRecord::Migration
  def change
    create_table :installments do |t|
      t.references :installment_plan
      t.integer :value
      t.date :paid_at

      t.timestamps
    end
    add_index :installments, :installment_plan_id
  end
end
