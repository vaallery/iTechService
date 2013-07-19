# encoding: utf-8
module DevicesHelper
  
  def row_class_for_task task
    if task.present?
      task.done ? 'success' : task.is_important? ? 'error' : 'warning'
    else
      ''
    end
  end
  
  def row_class_for_device(device)
    if device.at_done?
      'success'
    elsif device.in_archive?
      'info'
    end
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
          content_tag(:td, time) + content_tag(:td, location) + content_tag(:td, user)
        end
      end.join.html_safe
    end.html_safe
  end

  def device_movement_information_tag(device)
    user, time = device.moved_by, device.moved_at
    text = (user.present? and time.present?) ? t('moved', user: user.full_name, time:
        distance_of_time_in_words_to_now(time)) : '-'
    history_link_to(movement_history_device_path(device)) + content_tag(:span, text)
  end

  def itunes_string_for(device)
    "#{l device.created_at, format: :date_short}  #{device.ticket_number}  #{device.client.name}"
  end

  def returning_devices_list(devices)
    if devices.any?
      now = DateTime.current.change(sec: 0)
      content_tag(:table, id: 'returning_devices_list', class: 'table table-condensed table-hover') do
        devices.map do |device|
          content_tag(:tr) do
            time_text = "#{t('in_time') if device.return_at.future?} #{distance_of_time_in_words(now, device.return_at)} #{t('ago') if device.return_at.past?}"
            content_tag(:td, time_text) +
            content_tag(:td, link_to(device.presentation, device_path(device), target: '_blank')) +
            content_tag(:td, link_to(glyph(:phone), '#', class: 'returning_device_tooltip', data: {html: true, placement: 'top', trigger: 'manual', title: content_tag(:span, device.client_full_name) + tag(:br) + content_tag(:strong, human_phone(device.client_contact_phone))}))
          end
        end.join.html_safe
      end.html_safe
    else
      ''
    end
  end

  def header_link_for_device_returning
    devices = Device.for_returning
    notify_class = devices.any? ? 'notify' : ''
    content_tag(:li, id: 'device_returning', class: notify_class) do
      link_to glyph('mobile-phone'), '#', rel: 'popover', id: 'device_returning_link', data: { html: true, placement: 'bottom', title: t('devices.returning_popover_title'), content: returning_devices_list(devices).gsub('\n', '') }
    end
  end

end
