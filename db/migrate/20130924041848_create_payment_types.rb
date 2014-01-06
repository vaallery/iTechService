class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.string :name
      t.integer :kind

      t.timestamps
    end
    add_index :payment_types, :kind
  end
end
