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
      t('dashboard.device_not_found', default: 'Device not found')
    end
  end

  def link_to_move_device(device)
    link_to icon_tag('share'), edit_device_path(device), class: 'btn btn-small', remote: true
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
    current_user.admin? ? true : device.is_actual_for?(current_user)
  end

  def is_actual_task?(task)
    task.is_actual_for?(current_user)
  end

  def is_editable_task?(task)
    current_user.admin? ? true : task.is_actual_for?(current_user)
  end

  def device_row_tag(device)
    content_tag(:tr, class: 'info device_row', data: {device_id: device.id}) do
      content_tag(:td, device_movement_information_tag(device), class: 'device_movement_column') +
        content_tag(:td, class: 'device_task_column') do
        content_tag(:span, device.progress, class: "device_tasks_toggle #{progress_badge_class_for_device(device)}") +
        link_to(device.presentation, device_path(device), target: '_blank') +
        tag(:br, false) +
        content_tag(:span, class: 'device_ticket_number') do
          "#{Device.human_attribute_name(:ticket_number)}: #{device.ticket_number}"
        end
      end +
      content_tag(:td, class: 'client_comment_column') do
        (device.client.present? ? link_to(device.client_presentation, client_path(device.client), target: '_blank') : '-').html_safe +
        tag(:br, false) +
        device.comment
      end +
      content_tag(:td, link_to_move_device(device), class: 'device_task_action_column')
    end
  end

  def made_device_row_tag(device)
    content_tag(:tr, class: 'device_row', data: {device_id: device.id}) do
      content_tag(:td, device_movement_information_tag(device), class: 'device_movement_column') +
      content_tag(:td) do
        link_to(device.presentation, device_path(device), target: '_blank')
      end +
      content_tag(:td) do
        link_to(device.client_presentation, client_path(device.client), target: '_blank') +
        tag(:br, false) +
        device.comment
      end +
      content_tag(:td, l(device.done_at, format: :long_d)) +
      content_tag(:td, link_to_move_device(device))
    end
  end

  def device_task_row_tag(device_task)
    row_class = device_task.done ? 'success' : (is_actual_task?(device_task) ? 'error' : 'warning')
    content_tag(:tr, class: "device_task_row #{row_class}", data: {device_task_id: device_task.id,
                 device_id: device_task.device_id, task_id: device_task.task_id}) do
      content_tag(:td, nil) +
      content_tag(:td, device_task.task_name) +
      content_tag(:td, device_task.comment) +
      content_tag(:td, is_editable_task?(device_task) ? link_to_edit_device_task(device_task) : nil)
    end.html_safe
  end

end
