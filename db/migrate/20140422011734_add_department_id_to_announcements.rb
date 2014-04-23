class AddDepartmentIdToAnnouncements < ActiveRecord::Migration
  class Announcement < ActiveRecord::Base
    attr_accessible :department_id
  end

  def change
    add_column :announcements, :department_id, :integer
    add_index :announcements, :department_id

    Announcement.unscoped.find_each do |announcement|
      announcement.update_attributes! department_id: Department.current.id
    end
  end
end
