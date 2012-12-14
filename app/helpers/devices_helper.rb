module DevicesHelper
  
  def row_class_for_task task
    if task.present?
      task.done ? 'success' : task.is_important? ? 'error' : 'warning'
    else
      ''
    end
  end
  
  def row_class_for_device device
    device.done? ? 'success' : device.is_important? ? 'error' : 'warning'
  end

  def device_moved_by device
    #debugger
    if (rec = device.history_records.where(column_name: 'location_id').order('updated_at desc').first).present?
      rec.user.username
    else
      nil
    end
  end

  def device_moved_at device
    if (rec = device.history_records.where(column_name: 'location_id').order('updated_at desc').first).present?
      human_datetime rec.updated_at
    else
      nil
    end
  end
  
end
