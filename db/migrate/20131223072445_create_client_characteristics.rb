class CreateClientCharacteristics < ActiveRecord::Migration
  def change
    create_table :client_characteristics do |t|
      t.references :client_category
      t.text :comment

      t.timestamps
    end
    add_index :client_characteristics, :client_category_id
  end
end
