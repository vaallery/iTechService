class CreateTopSalables < ActiveRecord::Migration
  def change
    create_table :top_salables do |t|
      t.references :salable, polymorphic: true
      t.integer :position
      t.string :color

      t.timestamps
    end
    add_index :top_salables, [:salable_type, :salable_id]
  end
end
