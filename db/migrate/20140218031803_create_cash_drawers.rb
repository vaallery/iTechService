class CreateCashDrawers < ActiveRecord::Migration
  def change
    create_table :cash_drawers do |t|
      t.string :name
      t.references :department

      t.timestamps
    end
    add_index :cash_drawers, :department_id
  end
end
