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

  def progress_badge_class_for_device device
    badge_class = 'badge-'
    badge_class << (device.done_tasks.count == 0 ? 'important' : 'info')
  end

  def device_moved_by device
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

  def task_list_for device
    content_tag(:ul, style: 'list-style:none; text-align:left; margin:0') do
      device.device_tasks.collect do |task|
        content_tag(:li, "#{icon_tag(task.done ? 'check' : 'check-empty')} #{task.task_name}")
      end.join.html_safe
    end.html_safe
  end

  def clients_autocomplete_list clients = []
    if clients.any?
      clients.collect do |client|
        content_tag :li, link_to(client.presentation, select_client_devices_path(client_id: client.id), remote: true)
      end.join.html_safe
    else
      content_tag(:li, link_to(t(:nothing_found), '#', remote: true)).html_safe
    end
  end
  
end
