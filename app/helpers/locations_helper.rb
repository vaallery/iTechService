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
            content_tag(:label, class: 'radio') do
              form.radio_button(name, location.id) + location.name
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

end
