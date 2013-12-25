class AddTechNoticeToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :tech_notice, :text
  end
end
