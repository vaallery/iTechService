class AddDepartmentIdToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :department_id, :integer
    add_index :announcements, :department_id
  end
end
