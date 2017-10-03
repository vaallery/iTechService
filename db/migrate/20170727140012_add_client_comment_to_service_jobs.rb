class AddClientCommentToServiceJobs < ActiveRecord::Migration
  def change
    add_column :service_jobs, :client_comment, :text
  end
end
