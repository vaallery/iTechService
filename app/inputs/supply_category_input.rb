class SupplyCategoryInput < SimpleForm::Inputs::Base

  def input
    template.content_tag(:span, class: 'supply_category_selector') do
      @builder.hidden_field(attribute_name.to_s+'_id') +
      template.content_tag(:div, class: 'btn-group') do
        template.link_to('#', class: 'supply_category_select_button btn', 'data-toggle' => 'dropdown') do
          template.content_tag(:span, class: 'supply_category_name pull-left') do
            @builder.object.supply_category.blank? ? '-' : @builder.object.supply_category.try(:name)
          end +
          template.content_tag(:span, nil, class: 'caret pull-right')
        end +
        template.content_tag(:ul, class: 'supply_categories_list dropdown-menu') do
          template.make_supply_categories_list(SupplyCategory.roots)
        end
      end
    end.html_safe
  end

end