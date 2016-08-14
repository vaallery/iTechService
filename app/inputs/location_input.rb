class LocationInput < SimpleForm::Inputs::Base

  def input(wrapper_options = nil)
    user = options[:user]
    (@builder.hidden_field(attribute_name) +
    template.content_tag(:span, class: 'btn-group') do
      template.content_tag(:button, id: 'locations_select_button', class: 'btn dropdown-toggle',
                           'data-toggle' => 'dropdown') do
        template.content_tag(:span, id: 'location_value', class: 'pull-left') do
          @builder.object.location.blank? ? '-' : @builder.object.location.name
        end +
        template.content_tag(:span, nil, class: 'caret pull-right')
      end +
      template.content_tag(:ul, id: 'locations_list', class: 'dropdown-menu') do
        Location.allowed_for(user, @builder.object).map do |location|
          template.content_tag(:li, template.link_to(location.name, '#', location_id: location.id)) if location.present?
        end.join.html_safe
      end
    end
    ).html_safe
  end

end