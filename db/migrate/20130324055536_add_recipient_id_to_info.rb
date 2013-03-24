class AddRecipientIdToInfo < ActiveRecord::Migration
  def change
    add_column :infos, :recipient_id, :integer
    add_index :infos, :recipient_id
  end
end
