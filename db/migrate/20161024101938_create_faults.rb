class CreateFaults < ActiveRecord::Migration
  def change
    create_table :faults do |t|
      t.references :kind, null: false, index: true#, foreign_key: {to_table: :fault_kinds}
      t.date :date
      t.text :comment

      t.timestamps null: false
    end
    add_foreign_key :faults, :fault_kinds, column: :kind_id
  end
end
