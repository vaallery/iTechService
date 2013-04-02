# encoding: utf-8
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
    badge_class = 'badge badge-'
    badge_class << (device.done_tasks.count == 0 ? 'important' : (device.pending? ? 'warning' : 'success'))
  end

  def device_moved_by device
    (user = device.moved_by).present? ? user.username : '-'
  end

  def device_moved_at device
    (time = device.moved_at).present? ? human_datetime(time) : '-'
  end

  def task_list_for device
    content_tag(:ul, style: 'list-style:none; text-align:left; margin:0') do
      device.device_tasks.collect do |task|
        content_tag(:li, "#{icon_tag(task.done ? 'check' : 'check-empty')} #{task.task_name}")
      end.join.html_safe
    end.html_safe
  end

  def device_movement_history(device)
    history = device.movement_history
    content_tag(:table, class: 'movement_history ') do
      history.map do |h|
        time = h[0].present? ? l(h[0], format: :long_d) : '-'
        location = h[1].present? ? Location.find(h[1]).try(:full_name) || '-' : '-'
        user = h[2].present? ? User.find(h[2]).try(:full_name) || '-' : '-'
        content_tag(:tr) do
          content_tag(:td, time) +
          content_tag(:td, location) +
          content_tag(:td, user)
        end
      end.join.html_safe
    end.html_safe
  end

  def device_movement_information_tag(device)
    user, time = device.moved_by, device.moved_at
    text = (user.present? and time.present?) ? t('moved', user: user.full_name, time:
                                                 distance_of_time_in_words_to_now(time)) : '-'
    history_link_to(movement_history_device_path(device)) +
        content_tag(:span, text)
  end

  def itunes_string_for(device)
    "#{device.ticket_number} #{device.client.name} #{l device.created_at, format: :date_short}"
  end

end
