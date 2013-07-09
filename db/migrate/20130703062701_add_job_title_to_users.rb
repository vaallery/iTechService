class AddJobTitleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job_title, :string
    add_index :users, :job_title
  end
end
