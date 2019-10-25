class AddStorageTermToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :storage_term, :integer
  end
end
