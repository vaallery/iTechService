class AddLogToServiceFeedbacks < ActiveRecord::Migration
  def change
    add_column :service_feedbacks, :log, :text
  end
end
