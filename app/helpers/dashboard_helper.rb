module DashboardHelper

  def device_information_content(device)
    if device.present?
      (tag(:hr) +
          content_tag(:dl, class: 'dl-horizontal') do
            content_tag(:dt, Device.human_attribute_name(:client))
            content_tag(:dd, @device.client_presentation)
          end
      ).html_safe
    else
      t('devices.not_found', default: 'Device not found')
    end
  end

  def link_to_edit_device(device)
    link_to icon_tag(:edit), edit_device_path(device), class: 'btn btn-small', remote: true
            #, disabled: !is_movable_device?(device)
  end

  def link_to_edit_device_task(device_task)
    link_to icon_tag('edit'), edit_device_task_path(device_task), class: 'btn btn-small', remote: true,
            disabled: !is_editable_task?(device_task)
  end

  def is_actual_device?(device)
    device.is_actual_for?(current_user)
  end

  def is_movable_device?(device)
    current_user.any_admin? ? true : device.is_actual_for?(current_user)
  end

  def is_actual_task?(task)
    task.is_actual_for?(current_user)
  end

  def is_editable_task?(device_task)
    current_user.any_admin? ? true : device_task.is_actual_for?(current_user)
  end

  def device_row_tag(device)
    content_tag(:tr, class: 'info device_row', data: {device_id: device.id}) do
      content_tag(:td, device_movement_information_tag(device), class: 'device_movement_column') +
        content_tag(:td, class: 'device_task_column') do
        content_tag(:span, device.progress, class: "device_tasks_toggle #{progress_badge_class_for_device(device)}") +
        link_to(device.presentation, device_path(device)) +
        tag(:br, false) +
        content_tag(:span, class: 'device_ticket_number') do
          "#{Device.human_attribute_name(:ticket_number)}: #{device.ticket_number}"
        end
      end +
      content_tag(:td, class: 'client_comment_column') do
        (device.client.present? ? link_to(device.client_short_name, client_path(device.client)) : '-').html_safe +
        " #{contact_phones_for(device)}".html_safe +
        tag(:br, false) +
        device.comment
      end +
      content_tag(:td, class: 'device_task_action_column') do
        link_to_edit_device(device) +
        link_to(icon_tag('file-text-alt'), device_device_notes_path(device), class: 'btn btn-small', remote: true) +
        button_to_set_keeper_of_device(device)
      end
    end
  end

  def ready_device_row_tag(device)
    content_tag(:tr, class: 'device_row', data: {device_id: device.id}) do
      content_tag(:td, device_movement_information_tag(device), class: 'device_movement_column') +
      content_tag(:td) do
        link_to(device.presentation, device_path(device)) +
        tag(:br, false) +
        content_tag(:span, class: 'device_ticket_number') do
          "#{Device.human_attribute_name(:ticket_number)}: #{device.ticket_number}"
        end
      end +
      content_tag(:td) do
        link_to(device.client_presentation, client_path(device.client)) +
        tag(:br, false) +
        device.comment
      end +
      content_tag(:td, device.done_at.present? ? l(device.done_at, format: :long_d) : '-') +
      content_tag(:td, link_to_edit_device(device))
    end
  end

  def device_task_row_tag(device_task)
    content_tag(:tr, class: "device_task_row #{device_task.done_s} #{'actual' if is_actual_task?(device_task)}", data: {device_task_id: device_task.id, device_id: device_task.device_id, task_id: device_task.task_id}) do
      content_tag(:td, nil) +
      content_tag(:td, device_task.task_name) +
      content_tag(:td) do
        content_tag(:span, h(device_task.comment)) +
        tag(:br) +
        content_tag(:strong, h(device_task.user_comment), class: 'user_comment').html_safe
      end +
      content_tag(:td, is_editable_task?(device_task) ? link_to_edit_device_task(device_task) : nil)
    end.html_safe
  end

  def prepayment_details_content(details)
    content_tag(:table, class: 'table table-condensed') do
      details.map do |detail|
        content_tag(:tr) do
          content_tag(:td, detail[:date].strftime('%d.%m.%y')) +
          content_tag(:td, detail[:amount]) +
          content_tag(:td, detail[:comment])
        end
      end.join.html_safe
    end.gsub('\n', '')
  end

  def installment_details_content(details)
    content_tag(:table, class: 'table table-condensed') do
      details.map do |detail|
        content_tag(:tr) do
          content_tag(:td, detail[:date].strftime('%d.%m.%y')) +
          content_tag(:td, detail[:value]) +
          content_tag(:td, detail[:object])
        end
      end.join.html_safe
    end.gsub('\n', '')
  end
end
