module Service
  class RepairReturn < ActiveRecord::Base
    self.table_name = 'service_repair_returns'

    belongs_to :service_job
    belongs_to :performer, class_name: 'User'
    delegate :spare_parts, to: :service_job, allow_nil: true
  end
end
