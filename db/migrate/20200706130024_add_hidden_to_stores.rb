class AddHiddenToStores < ActiveRecord::Migration
  def change
    add_column :stores, :hidden, :boolean
  end
end
