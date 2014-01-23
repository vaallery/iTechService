class AddIsReturnToSales < ActiveRecord::Migration
  def change
    add_column :sales, :is_return, :boolean
  end
end
