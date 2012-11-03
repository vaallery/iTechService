module ApplicationHelper

  def link_to_add_fields(name, append_to_selector, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder, index: "new_#{association}", options: options)
    end
    name = sanitize("<i class='icon-plus icon-white'/>") + ' ' + name
    # link_to(name, '#', onclick: "add_fields(\"#{append_to_selector}\", \"#{association}\",
        #  \"#{escape_javascript(fields)}\")", class: 'add_fields btn-mini btn-success btn', remote: true)
    link_to name, '#', class: 'add_fields btn-mini btn-success btn', 
        html_options: { param_selector: append_to_selector, param_association: association, param_content: j(fields)}
  end

  def link_to_remove_fields(f)
    f.hidden_field(:_destroy) <<
    link_to('#', class: 'remove_fields btn btn-mini btn-danger') do
      tag(:i, class: 'icon-minus icon-white')
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(sort: column, direction: direction, page: nil), {class: css_class, remote: true}
  end
  
  def search_button
    button_tag type: 'submit', class: "btn btn-info" do
      name = sanitize "<i class='icon-search icon-white'></i> #{t(:search)}"
    end
  end
  
end