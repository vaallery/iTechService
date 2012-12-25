module DashboardHelper

  def device_information_content device
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

end
