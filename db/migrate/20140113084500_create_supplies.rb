class CreateSupplies < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.references :supply_report
      t.references :supply_category
      t.string :name
      t.integer :quantity
      t.decimal :cost

      t.timestamps
    end
    add_index :supplies, :supply_report_id
    add_index :supplies, :supply_category_id
  end
end
