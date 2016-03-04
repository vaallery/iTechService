module ClientsHelper

  def client_devices_list client
    if client.present? and client.devices.any?
      content = content_tag(:ul, class: 'client_devices_list') do
        # client.devices.uniq_by{|d|d.device_type_id}.collect do |device|
        client.devices.distinct.collect do |device|
          content_tag(:li) do
            link_to device_select_devices_path(client, device_id: device.id),
                    id: "client_device_select_#{device.id}", class: 'client_device_select', remote: true do
              content_tag(:span, device.presentation) +
              content_tag(:span, "#{distance_of_time_in_words_to_now(device.created_at)} #{t(:ago)}", class: 'help-block')
            end
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

  def client_presentation(client)
    if client.present? then
      phone_number = number_to_phone client.full_phone_number || client.phone_number, area_code: true
      "#{client.short_name} / #{phone_number}"
    else
      '-'
    end
  end

  def client_categories_for_select
    Client::CATEGORIES.to_a.map {|c| [t("clients.categories.#{c[1]}"), c[0]]}
  end

  def human_client_category(client)
    client.present? ? t("clients.categories.#{client.category_s}") : ''
  end

  def client_link(client)
    client.present? ? link_to(client.short_name, client_path(client)) : ''
  end

end
