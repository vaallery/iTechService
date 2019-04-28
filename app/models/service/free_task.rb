module Service
  class FreeTask < ActiveRecord::Base
    self.table_name = 'service_free_tasks'
    mount_uploader :icon, IconUploader

    def to_s
      name
    end

    def possible_performers
      return User.none if code.nil?

      location_ids = Location.code_start_with(code).pluck(:id)
      location_ids.any? ? User.active.where(location_id: location_ids) : User.none
    end
  end
end
