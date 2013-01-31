module ClientsHelper

  def client_devices_list client
    if client.present? and client.devices.any?
      content = content_tag(:ul, class: 'client_devices_list') do
        client.devices.uniq_by{|d|d.device_type_id}.collect do |device|
          content_tag(:li) do
            link_to "#{device.type_name} / #{device.serial_number}",
                    device_select_devices_path(client, device_id: device.id),
                    id: "client_device_select_#{device.id}", class: 'client_device_select', remote: true
          end
        end.join.html_safe
      end
    else
      content = ''
    end
    content.html_safe
  end

  def clients_autocomplete_list clients = []
    if clients.any?
      clients.collect do |client|
        content_tag :li, link_to(client.presentation, select_client_path(client), remote: true)
      end.join.html_safe
    else
      content_tag(:li, link_to(t(:nothing_found), '#', remote: true)).html_safe
    end
  end

end
