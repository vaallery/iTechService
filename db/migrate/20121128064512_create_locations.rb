class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :ancestry

      t.timestamps
    end

    add_index :locations, :ancestry
  end
end
