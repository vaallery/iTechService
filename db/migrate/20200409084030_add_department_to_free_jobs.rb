class AddDepartmentToFreeJobs < ActiveRecord::Migration
  class ServiceFreeJob < ActiveRecord::Base; end

  def change
    add_reference :service_free_jobs, :department, index: true, foreign_key: true

    reversible do |dir|
      dir.up do
        department_id = Department.default.id

        ServiceFreeJob.where(department_id: nil).find_each do |job|
          job.update_column(:department_id, department_id)
        end

        change_column_null :service_free_jobs, :department_id, false
      end
    end
  end
end
