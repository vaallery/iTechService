class CreateOptionTypes < ActiveRecord::Migration
  def change
    create_table :option_types do |t|
      t.string :name, null: false, index: true
      t.string :code, index: true
      t.integer :position, null: false, default: 0

      t.timestamps null: false
    end
  end
end
