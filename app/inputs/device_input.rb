class DeviceInput < SimpleForm::Inputs::Base

  def input(wrapper_options=nil)
    template.content_tag(:div, class: 'device_input input-group input-append input-prepend') do
      presentation = @builder.object.item&.decorate&.presentation
      template.content_tag(:span, template.glyph(:search), class: 'input-group-addon add-on') +
      @builder.hidden_field("#{attribute_name}_id", class: 'item_id') +
      template.text_field_tag(:item_search, presentation, class: 'item_search form-control', placeholder: I18n.t('helpers.placeholders.item'), autocomplete: 'off', title: presentation) +
      template.link_to(template.glyph(:plus), template.new_device_path, class: 'new_item_btn btn btn-default', remote: true) +
      template.link_to(template.glyph(:edit), @builder.object.item.present? ? template.edit_device_path(@builder.object.item) : '#', class: 'edit_item_btn btn btn-default', remote: @builder.object.item.present?) +
      template.link_to(template.glyph('eye-open'), @builder.object.item.present? ? template.device_path(@builder.object.item) : '#', class: 'show_item_btn btn btn-default', remote: @builder.object.item.present?)
    end
  end

end
