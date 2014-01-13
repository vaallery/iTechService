class CreateSupplyCategories < ActiveRecord::Migration
  def change
    create_table :supply_categories do |t|
      t.string :name
      t.string :ancestry

      t.timestamps
    end
  end
end
