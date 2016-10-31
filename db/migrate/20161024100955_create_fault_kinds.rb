class CreateFaultKinds < ActiveRecord::Migration
  def change
    create_table :fault_kinds do |t|
      t.string :name
      t.string :icon
      t.boolean :is_permanent, null: false, default: false

      t.timestamps null: false
    end
  end
end
