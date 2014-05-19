class AddDepartmentIdToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :department_id, :integer
    add_index :announcements, :department_id

    Announcement.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
