class AddAbilitiesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :abilities_mask, :integer
  end
end
