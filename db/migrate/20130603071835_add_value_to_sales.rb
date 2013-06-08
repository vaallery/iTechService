class AddValueToSales < ActiveRecord::Migration
  def change
    add_column :sales, :value, :integer
  end
end
