class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.references :option_type, null: false, index: true, foreign_key: true
      t.string :name, null: false, index: true
      t.string :code, index: true
      t.integer :position, null: false, default: 0

      t.timestamps null: false
    end
  end
end
