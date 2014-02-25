class AddCategoryToClients < ActiveRecord::Migration
  def change
    add_column :clients, :category, :integer
    add_index :clients, :category
  end
end
