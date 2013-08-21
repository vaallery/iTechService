class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :code
      t.references :group

      t.timestamps
    end
    add_index :products, :group_id
  end
end
