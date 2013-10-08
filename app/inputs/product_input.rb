class ProductInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:div, class: "product_selector #{options[:form]}") do
      @builder.hidden_field("#{attribute_name}_id", class: "#{attribute_name}_id") +
      template.content_tag(:div, class: 'btn-group') do
        template.link_to(@builder.object.name || '-', template.choose_products_path(form: options[:form]), remote: true, class: 'product_select_button btn', title: @builder.object.name || '-') +
        template.link_to(template.glyph('remove'), '#', class: 'btn clear_product')
      end
    end.html_safe
  end

end
