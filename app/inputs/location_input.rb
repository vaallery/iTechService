class LocationInput < SimpleForm::Inputs::Base

  def input
    user = options[:user]
    (@builder.hidden_field(:location_id) +
    template.content_tag(:span, class: 'btn-group') do
      template.content_tag(:button, id: 'locations_select_button', class: 'btn dropdown-toggle',
                           'data-toggle' => 'dropdown') do
        template.content_tag(:span, id: 'location_value', class: 'pull-left') do
          @builder.object.location.blank? ? '-' : Location.find(@builder.object.location.id).full_name
        end +
        template.content_tag(:span, nil, class: 'caret pull-right')
      end +
      template.content_tag(:ul, id: 'locations_list', class: 'dropdown-menu') do
        template.available_locations_for(user).map do |location|
          template.content_tag(:li, template.link_to(location.full_name, '#', location_id: location.id))
        end.join.html_safe
      end
    end
    ).html_safe
  end

end