module LocationsHelper

  def choose_location_for form
    name = form.object.is_a?(Location) ? 'parent_id' : 'location_id'
    locations = Location.scoped
    content = ''
        #content_tag :label, class: 'radio' do
        #  form.radio_button(name, ) + 'none'
        #end
    locations.each do |location|
      unless location === form.object
        content +=
            content_tag :label, class: 'radio' do
              form.radio_button(name, location.id) + location.full_name
            end
      end
    end
    content_tag :div, class: 'control-group' do
      form.label(name) +
      content_tag(:div, class: 'controls') do
        content.html_safe
      end
    end.html_safe
  end

  def available_locations
    available_locations_for current_user
  end

  def available_locations_for user
    if user.admin? or user.location.nil?
      Location.all
    else
      Location.allowed_for(user)
    end
  end

end
