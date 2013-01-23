module ClientsHelper

  def client_devices_list client
    if client.present? and client.devices.any?
      content = content_tag(:ul, class: 'client_devices_list') do
        client.devices.collect do |device|
          content_tag(:li) do
            link_to "#{device.type_name} / #{device.serial_number}",
                    select_device_client_path(client, device_id: device.id),
                    id: "client_device_select_#{device.id}", class: 'client_device_select', remote: true
          end
        end.join.html_safe
      end
    else
      content = ''
    end
    content.html_safe
  end

end
