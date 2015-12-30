# encoding: utf-8
module DevicesHelper
  
  def row_class_for_task task
    if task.present?
      task.done? ? 'success' : task.pending? ? (task.is_important? ? 'error' : 'warning') : ''
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
    badge_class << (device.processed_tasks.count == 0 ? 'important' : (device.pending? ? 'warning' : 'success'))
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
        location = h[1].present? ? Location.find(h[1]).try(:name) || '-' : '-'
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
            content_tag(:td, link_to(glyph(:phone), '#', class: 'returning_device_tooltip', data: {html: true, placement: 'top', trigger: 'manual', title: content_tag(:span, device.client_full_name) + tag(:br) + content_tag(:strong, human_phone(device.contact_phone))}))
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

  def contact_phones_for(device)
    if device.client.present?
      phones = []
      phones << human_phone(device.client.contact_phone) unless device.client.contact_phone.blank?
      phones << human_phone(device.client.full_phone_number) unless device.client.full_phone_number.blank?
      phones << human_phone(device.client.phone_number) unless device.client.phone_number.blank?
      phones.join ', '
    end
  end

  def sales_info(device)
    content = []
    if (number = device.serial_number.present? ? device.serial_number : device.imei).present?
      if (item = Item.search(q: number, saleinfo: true).first).present?
        content << content_tag(:span, item.sale_info[:sale_info], class: 'sales_info')
      end
      if (imported_sales = ImportedSale.search(search: number)).any?
        content << content_tag(:span, imported_sales.map { |sale| "[#{sale.sold_at.strftime('%d.%m.%y')}: #{sale.quantity}]" }.join(' '), class: 'imported_sales_info')
      end
      content.present? ? content.join(' ').html_safe : '-'
    else
      '?'
    end
  end

  def link_to_archive_device(device, options={})
    link_to glyph(:archive)+t('devices.move_to_archive'), device_path(device, device: {location_id: current_user.archive_location.id}), method: :put, class: 'btn btn-warning', remote: options[:remote]
    # link_to glyph(:archive)+t('devices.move_to_archive'), device_path(device, device: {location_id: Location.archive.id}), method: :put, class: 'btn btn-warning', remote: options[:remote]
  end

  def device_tasks_list(device)
    content_tag(:ul, id: 'device_tasks_list') do
      device.device_tasks.collect do |device_task|
        content_tag :li do
          content_tag(:div, device_task.name) +
          content_tag(:div, device_task.comment, class: 'text-info') +
          content_tag(:div, device_task.user_comment, class: 'text-error') +
          content_tag(:div, "#{distance_of_time_in_words_to_now(device_task.created_at)} #{t(:ago)}", class: 'muted')
        end
      end.join.html_safe
    end
  end

  def button_to_set_keeper_of_device(device)
    button_class = 'device-keeper-button btn btn-small'
    hint = "#{Device.human_attribute_name(:keeper)}: "
    if device.keeper.present?
      button_class += ' btn-info'
      hint += device.keeper.short_name
    else
      button_class += ' btn-default'
      hint += '-'
    end
    form_for [:set_keeper, device], remote: true, html: {class: 'button_to device-keeper-form'} do |f|
      # hidden_field_tag('device[keeper_id]', current_user.id) +
      button_tag(glyph('user'), class: button_class, title: hint)
    end
  end
end
