module ApplicationHelper

  def link_to_add_fields(name, append_to_selector, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder, index: "new_#{association}", options: options)
    end
    #name = sanitize("<i class='icon-plus icon-white'/>") + ' ' + name
    #link_to(name, '#', onclick: "add_fields(\"#{append_to_selector}\", \"#{association}\",
    #     \"#{escape_javascript(fields)}\")", class: 'add_fields btn-mini btn-success btn', remote: true)
    link_to name, '#', class: 'add_fields btn-mini btn-success btn', 
        data: { selector: append_to_selector, association: association, content: (fields.gsub('\n', '')) }
  end

  def link_to_remove_fields(f)
    content_tag :span do
      f.hidden_field(:_destroy) +
      link_to(t('remove'), '#', class: 'remove_fields btn btn-mini btn-danger')
      #link_to('#', class: 'remove_fields btn btn-mini btn-danger') {tag('i', class: 'icon-minus icon-white')}
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    if column == sort_column
      css_class = "current #{sort_direction} nav nav-pills"
      direction = sort_direction == "asc" ? "desc" : "asc"
      icon_name = (sort_direction == 'asc') ? 'caret-up' : 'caret-down'
    else
      css_class = 'nav nav-pills'
      icon_name = 'sort'
      direction = 'asc'
    end
    title = "#{title} <i class='icon-#{icon_name}'></i>".html_safe
    link_to title, params.merge(sort: column, direction: direction, page: nil), {class: css_class, remote: false}
  end
  
  def search_button
    button_tag type: 'submit', class: "btn btn-info" do
      name = sanitize "<i class='icon-search icon-white'></i> #{t(:search)}"
    end
  end
  
  def timestamp_string_for object
    "[#{object.class.human_attribute_name(:created_at)}: #{l(object.created_at, format: :long_d)} | " +
      "#{object.class.human_attribute_name(:updated_at)}: #{l(object.updated_at, format: :long_d)}]"
  end
  
  def nav_state_for controller
    params[:controller] == controller ? 'active' : ''
  end
  
end