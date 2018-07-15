class DeviceTypesReport < BaseReport
  attr_accessor :device_type

  def call
    result[:device_types] = []
    result[:service_jobs_received_count] = result[:service_jobs_received_done_count] = result[:service_jobs_received_archived_count] = 0
    result[:current_device_type] = DeviceType.find(device_type) if device_type.present?
    device_types = result[:current_device_type].present? ? result[:current_device_type].children : DeviceType.roots
    device_types.each do |device_type|
      job_ids = []
      if device_type.is_childless?
        job_ids += device_type.service_jobs.where(created_at: period).pluck(:id)
        job_ids += ServiceJob.includes(item: {product: :device_type}).
          where(created_at: period, products: {device_type_id: device_type.id}).pluck(:id)
      else
        device_type.descendants.each do |sub_device_type|
          if sub_device_type.is_childless?
            job_ids += sub_device_type.service_jobs.where(created_at: period).pluck(:id)
            job_ids += ServiceJob.includes(item: {product: :device_type}).
              where(created_at: period, products: {device_type_id: sub_device_type.id}).pluck(:id)
          end
        end
      end
      received_service_jobs = ServiceJob.where id: job_ids
      qty_received = received_service_jobs.count
      qty_done = received_service_jobs.at_done.count
      qty_archived = received_service_jobs.at_archive.count
      result[:device_types] << {device_type: device_type, qty: qty_received, qty_done: qty_done, qty_archived: qty_archived}
      result[:service_jobs_received_count] += qty_received
      result[:service_jobs_received_done_count] += qty_done
      result[:service_jobs_received_archived_count] += qty_archived
    end
    result
  end
end