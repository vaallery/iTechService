class AddKindToStores < ActiveRecord::Migration
  def change
    add_column :stores, :kind, :string
  end
end
