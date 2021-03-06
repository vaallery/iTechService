class AddDepartmentIdToAnnouncements < ActiveRecord::Migration
  class Announcement < ActiveRecord::Base; end
  def change
    add_column :announcements, :department_id, :integer
    add_index :announcements, :department_id

    Announcement.unscoped.find_each do |r|
      r.update_column :department_id, Department.current.id
    end
  end
end
