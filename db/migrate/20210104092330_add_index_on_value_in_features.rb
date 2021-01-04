class AddIndexOnValueInFeatures < ActiveRecord::Migration
  def change
    add_index :features, :value
  end
end
