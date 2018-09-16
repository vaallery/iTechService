class DeviceInput < SimpleForm::Inputs::Base

  def input(wrapper_options=nil)
    template.content_tag(:div, class: "device_input input-group input-append input-prepend") do
      template.content_tag(:span, template.glyph(:search), class: 'input-group-addon add-on') +
      @builder.hidden_field("#{attribute_name}_id", class: 'item_id') +
      template.text_field_tag(:item_search, presentation, class: "item_search form-control has-tooltip", placeholder: I18n.t('helpers.placeholders.item'), autocomplete: 'off', title: status_info, data: {html: true, container: 'body', status: status}) +
      template.link_to(template.glyph(:plus), template.new_device_path, class: 'new_item_btn btn btn-default', remote: true) +
      template.link_to(template.glyph(:edit), device.present? ? template.edit_device_path(device) : '#', class: 'edit_item_btn btn btn-default', remote: device.present?) +
      template.link_to(template.glyph('eye-open'), device.present? ? template.device_path(device) : '#', class: 'show_item_btn btn btn-default', remote: device.present?)
    end
  end

  private

  def device
    @builder.object.item
  end

  def device_presenter
    device&.decorate
  end

  def status
    device_presenter&.status
  end

  def status_info
    device_presenter&.status_info
  end

  def presentation
    device_presenter&.presentation
  end
end
