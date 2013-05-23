class AddIsArchivedToInfos < ActiveRecord::Migration
  def change
    add_column :infos, :is_archived, :boolean, default: false
  end
end
