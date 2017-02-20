class AddEmailToServiceJob < ActiveRecord::Migration
  def change
    add_column :service_jobs, :email, :string
  end
end
