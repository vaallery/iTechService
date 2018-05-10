module Service
  class FreeTask < ActiveRecord::Base
    self.table_name = 'service_free_tasks'
    mount_uploader :icon, IconUploader

    def to_s
      name
    end
  end
end
