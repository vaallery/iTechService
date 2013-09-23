class ProductInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:div, class: 'product_selector') do
      @builder.hidden_field(attribute_name, class: 'item_id') +
      template.content_tag(:div, class: 'btn-group') do
        template.link_to(@builder.object.presentation, template.choose_products_path(item: @builder.object.item_id), remote: true, class: 'product_select_button btn') +
        template.link_to(template.glyph('remove'), '#', class: 'btn clear_product')
      end
    end.html_safe
  end

  def input2
    template.content_tag(:div, class: 'product_selector') do
      @builder.hidden_field(attribute_name, class: 'product_id') +
      template.content_tag(:div, class: 'input-append input-prepend') do
        template.content_tag(:div, class: 'btn-group') do
          template.link_to(template.glyph('remove'), '#', class: 'btn clear_product') +
          template.content_tag(:button, class: 'product_select_button btn dropdown-toggle', 'data-toggle' => 'dropdown') do
            template.content_tag(:span, class: 'product_name pull-left') do
              @builder.object.item.blank? ? '-' : @builder.object.item.name
            end +
            template.content_tag(:span, nil, class: 'caret pull-right')
          end +
          template.content_tag(:ul, class: 'products_list dropdown-menu unstyled') do
            template.product_select_list
          end
        end
      end
    end.html_safe
  end

end
