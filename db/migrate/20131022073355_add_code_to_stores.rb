class AddCodeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :code, :string
    add_index :stores, :code
  end
end
