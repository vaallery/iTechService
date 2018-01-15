class DropdownInput < SimpleForm::Inputs::CollectionInput
  delegate :content_tag, :link_to, to: :template

  def input(wrapper_options = nil)
    label_method, value_method = detect_collection_methods

    content_tag :div, class: 'dropdown-input' do
      @builder.hidden_field(attribute_name, class: 'input-value') +
      content_tag(:span, class: 'btn-group') do
        content_tag(:button, class: 'btn dropdown-toggle', 'data-toggle' => 'dropdown') do
          content_tag(:span, class: 'input-presentation pull-left') do
            label_method.call(@builder.object&.public_send(reflection_or_attribute_name)) || '-'
          end +
          content_tag(:span, nil, class: 'caret pull-right')
        end +
        content_tag(:ul, class: 'dropdown-menu') do
          collection.map do |item|
            content_tag(:li, link_to(label_method.call(item), '#', class: 'dropdown-input-item', data: {value: item.id}))
          end.join.html_safe
        end
      end
    end
  end
end
