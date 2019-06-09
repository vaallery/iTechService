class AddInitialDepartmentToServiceJobs < ActiveRecord::Migration
  def change
    add_reference :service_jobs, :initial_department, index: true
    add_foreign_key :service_jobs, :departments, column: :initial_department_id
  end
end
