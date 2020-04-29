class ReplaceLocationIdWithLocationCodeInTasks < ActiveRecord::Migration
  class Task < ActiveRecord::Base; end
  class Location < ActiveRecord::Base; end

  def change
    add_column :tasks, :location_code, :string

    reversible do |dir|
      dir.up do
        Task.find_each do |task|

          if task.location_id.present?
            location = Location.find(task.location_id)
            task.update_column(:location_code, location.code)
          end
        end
      end
    end

    remove_column :tasks, :location_id
  end
end
