class AddKarmaGroupIdToKarmas < ActiveRecord::Migration
  def change
    add_column :karmas, :karma_group_id, :integer
    add_index :karmas, :karma_group_id
  end
end
