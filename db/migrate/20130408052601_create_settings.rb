class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :presentation
      t.string :value
      t.string :value_type

      t.timestamps
    end

    add_index :settings, :name
  end
end
