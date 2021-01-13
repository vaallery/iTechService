class AddIndexOnNameInProducts < ActiveRecord::Migration
  def change
    add_index :products, :name
  end
end
