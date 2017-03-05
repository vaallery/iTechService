class AddIsHiddenToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :hidden, :boolean, default: false
  end
end
