class AddAttributesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :quantity_threshold, :integer
    add_column :products, :comment, :text
  end
end
