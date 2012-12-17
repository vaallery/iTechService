module ApplicationHelper

  def link_to_add_fields(name, append_to_selector, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder, index: "new_#{association}", options: options)
    end
    name = "<i class='icon-plus'>" + ' ' + name + '</i>'
    link_to '#', class: 'add_fields btn-mini btn-success btn', 
        data: { selector: append_to_selector, association: association, content: (fields.gsub('\n', '')) } do
      name.html_safe
    end
  end

  def link_to_remove_fields(f)
    content_tag :span do
      f.hidden_field(:_destroy) +
      link_to('#', class: 'remove_fields btn btn-mini btn-danger'){tag('i', class: 'icon-minus')}
    end
  end

  def link_back_to_index
    link_to ("<i class='icon-chevron-left'></i>").html_safe, url_for(action: 'index', controller: params[:controller]), style: "text-decoration:none;"
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
  
  def link_to_show object, options = {}
    options.merge! class: 'btn btn-small'
    link_to(url_for(controller: object.class.name.tableize, action: 'show', id: object.id), options) do
      "<i class='icon-eye-open'></i>".html_safe
    end
  end
  
  def link_to_edit object, options = {}
    options.merge! class: 'btn btn-small'
    link_to(url_for(controller: object.class.name.tableize, action: 'edit', id: object.id), options) do
      "<i class='icon-edit'></i>".html_safe
    end
  end
  
  def link_to_destroy object, options = {}
    options.merge! class: 'btn btn-small btn-danger', method: 'delete',
        data: {confirm: t('helpers.links.confirm', default: 'Are you sure?')}
    link_to(url_for(controller: object.class.name.tableize, action: 'destroy', id: object.id), options) do
      "<i class='icon-trash'></i>".html_safe
    end
  end
  
  def human_history_value rec #value, type
    case rec.column_type
    when 'boolean'
      icon_class = rec.new_value == 't' ? 'icon-check' : 'icon-check-empty'
      val = "<i class=#{icon_class}></i>"
    when 'integer'
      case rec.column_name
      when 'client_id'
        val = Client.find(rec.new_value).try :name_phone
      when 'location_id'
        val = Location.find(rec.new_value).try :full_name
      when 'device_id'
        val = Device.find(rec.new_value).try :presentation
      when 'task_id'
        val = Task.find(rec.new_value).try :name
      end
    else
      val = rec.new_value
    end
    val.html_safe
  end

  def attribute_changed_by object, attribute
    object.history_records
  end

  def human_date date
    date.present? ? l(date, format: :default) : ''
  end

  def human_datetime date
    date.present? ? l(date, format: :long_d) : ''
  end

  def profile_link
    icon_class = current_user.admin? ? 'icon-user-md' : 'icon-user'
    link_to profile_path do
      ("<i class='#{icon_class}'></i>" + current_user.username).html_safe
    end
  end

  def date_field form, attr
    content_tag(:div, class: 'input-append') do
      form.text_field(attr, class: 'span5') +
          link_to("<i class='icon-calendar'></i>".html_safe, '#', class: 'btn datepicker')
    end
  end

end