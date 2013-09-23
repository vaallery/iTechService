module ApplicationHelper

  def link_to_add_fields(name, append_to_selector, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", f: builder, index: "new_#{association}", options: options)
    end
    link_to '#', class: 'add_fields btn-mini btn-success btn',
        data: { selector: append_to_selector, association: association, content: (fields.gsub('\n', '')) } do
      icon_tag(:plus) + name
    end
  end

  def link_to_remove_fields(f)
    content_tag :span do
      f.hidden_field(:_destroy) +
      link_to('#', class: 'remove_fields btn btn-mini btn-danger'){tag('i', class: 'icon-minus')}
    end
  end

  def link_back_to_index
    link_to glyph('chevron-left'), url_for(action: 'index', controller: controller_name), class: "link_back"
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
    title = "#{title} #{icon_tag(icon_name)}".html_safe
    link_to title, params.merge(sort: column, direction: direction, page: nil), {class: css_class, remote: false}
  end

  def search_button
    button_tag type: 'submit', class: "btn btn-info" do
      icon_tag(:search) + t(:search)
    end
  end

  def timestamp_string_for object
    "[#{object.class.human_attribute_name(:created_at)}: #{l(object.created_at, format: :long_d)} | " +
      "#{object.class.human_attribute_name(:updated_at)}: #{l(object.updated_at, format: :long_d)}]"
  end

  def nav_state_for controller
    controller_name == controller ? 'active' : ''
  end

  def link_to_new object_class, name = nil, options = {}
    options.merge! class: 'btn btn-success btn-large'
    name ||= t('new')
    link_to url_for(controller: object_class.name.tableize, action: 'new'), options do
      "#{glyph(:file)} #{name}".html_safe
    end
  end

  def link_to_show object, options = {}
    options.merge! class: 'btn'
    name = t 'show'
    link_to url_for(controller: object.class.name.tableize, action: 'show', id: object.id), options do
      "#{glyph(:eye)} #{name}".html_safe
    end
  end

  def link_to_edit object, options = {}
    options.merge! class: 'btn'
    name = t 'edit'
    link_to url_for(controller: object.class.name.tableize, action: 'edit', id: object.id), options do
      "#{glyph(:edit)} #{name}".html_safe
    end
  end

  def link_to_destroy object, options = {}
    options.merge! class: 'btn btn-danger', method: 'delete',
        data: {confirm: t('confirmation', default: 'Are you sure?')}
    name = t 'destroy'
    link_to url_for(controller: object.class.name.tableize, action: 'destroy', id: object.id), options do
      "#{glyph(:trash)} #{name}".html_safe
    end
  end

  def submit_button form, options = {}
    options.merge! class: 'submit_button btn btn-primary ' + (options[:class] || ''), type: 'submit'
    model_name = form.object.class.model_name
    human_model_name = model_name.human
    action = form.object.new_record? ? 'create' : 'update'
    if options[:name] == false
      name = nil
    else
      name = options[:name] || t("helpers.button.#{model_name}.#{action}", model: human_model_name, default: t(action, default: 'Save'))
    end
    button_tag options do
      "#{glyph(:save)} #{name}".html_safe
    end
  end

  def link_to_show_small object, options = {}
    options.merge! class: 'btn btn-small'
    link_to icon_tag('eye-open'), url_for(controller: object.class.name.tableize, action: 'show', id: object.id), options
  end

  def link_to_edit_small object, options = {}
    options.merge! class: 'btn btn-small'
    link_to icon_tag(:edit), url_for(controller: object.class.name.tableize, action: 'edit', id: object.id), options
  end

  def link_to_destroy_small object, options = {}
    options.merge! class: 'btn btn-small btn-danger', method: 'delete',
        data: {confirm: t('helpers.links.confirm', default: 'Are you sure?')}
    link_to icon_tag(:trash), url_for(controller: object.class.name.tableize, action: 'destroy', id: object.id), options
  end

  def human_history_value rec #value, type
    if rec.new_value.present?
      case rec.column_type
      when 'boolean'
        icon_class = rec.new_value == 't' ? 'check' : 'check-empty'
        val = icon_tag icon_class
      when 'integer'
        case rec.column_name
          when 'client_id'
            val = Client.find(rec.new_value).try(:full_name)
          when 'location_id'
            val = Location.find(rec.new_value).try(:full_name)
          when 'device_id'
            val = Device.find(rec.new_value).try(:presentation)
          when 'task_id'
            val = Task.find(rec.new_value).try(:name)
          when 'nominal'
            val = rec.object.is_a?(GiftCertificate) ? rec.object.nominal_h : rec.new_value
          when 'status'
            val = rec.object.is_a?(GiftCertificate) ? rec.object.status_h : rec.new_value
          else
            val = rec.new_value
        end
      else
        val = rec.new_value
      end
    else
      val = '-'
    end
    #val.html_safe
    val
  end

  def attribute_changed_by(object, attribute)
    object.history_records
  end

  def human_date(date)
    date.present? ? l(date, format: :default) : ''
  end

  def human_datetime(date)
    date.present? ? l(date, format: :long_d) : ''
  end

  def date_field(form, attr)
    content_tag(:div, class: 'input-append') do
      form.text_field(attr, class: 'span5') +
          link_to(glyph(:calendar), '#', class: 'btn datepicker')
    end
  end

  def icon_tag(name, type = nil)
    white_class = type.to_s == 'white' ? 'icon-white' : ''
    "<i class='icon-#{name.to_s} #{white_class}'></i> ".html_safe
  end

  def title_for(model_class)
    case action_name
      when 'index'
        t '.title'
      when 'show'
        t '.title', default: model_class.model_name.human
      else
        t '.title', default: t("#{action_name.humanize} #{model_class.model_name.human}")
    end
  end

  def auto_title
    title_for controller_name.classify.constantize
  end

  def auto_header_tag(object=nil, title=nil, button_name=nil)
    model_class = controller_name.classify.constantize
    title ||= object.nil? ? auto_title : t("#{object.class.name.tableize}.#{object.new_record? ? 'new' : 'edit'}.title")
    button_name ||= t 'create'
    content_tag :div, class: 'page-header' do
      if action_name == 'index'
        content_tag(:h1, title) + ((can?(:create, model_class)) ? link_to_new(model_class, button_name) : '')
      else
        content_tag :h1, link_back_to_index + title
      end
    end
  end

  def caret_tag
    content_tag(:b, nil, class: 'caret').html_safe
  end

  def history_link_to(url)
    link_to glyph(:time), url, class: 'history_link', remote: true
  end

  def store_location
    session[:return_to] = request.fullpath.gsub(/.js/,'')
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def redirect_back_or(default, options = {})
    redirect_to session[:return_to] || default, options
    clear_return_to
  end

  def button_to_close_popover
    link_to "&times;".html_safe, '#', class: 'close_popover_button'
  end

  def button_to_close_modal
    content_tag(:a, glyph('remove-sign'), class: 'close_modal_button', 'data-dismiss' => 'modal', href: '#')
  end

  def humanize_duration(val)
    h = (val/60).round
    m = (val%60).round
    h > 0 ? t('hour_min', hour: h, min: m) : t('min', min: m)
  end

  def human_percent(value)
    number_to_percentage value, precision: 0
  end

  def human_currency(value)
    number_to_currency value, precision: 0, delimiter: ' ', separator: ','
  end

  def human_phone(value)
    number_to_phone value, area_code: true
  end

  def spinner_tag
    content_tag(:b, glyph('spinner'), id: 'spinner')
  end

  def header_link_to_scan_barcode
    content_tag(:li) do
      link_to glyph(:barcode), '#', remote: true, id: 'scan_barcode_button'
    end.html_safe
  end

  def document_presentation(document)
    t 'document', name: t("activerecord.models.#{document.class.to_s.downcase}"), num: document.id, time: human_datetime(document.created_at)
  end

  def button_to_post(document)
    #content_tag(:div, class: 'post_button') do
    #  form_for(document) do |f|
    #    concat hidden_field_tag("#{document.class.to_s.downcase}[status]", 1)
    #    concat button_tag("#{glyph('check')} #{t('post')}".html_safe, type: 'submit', class: 'btn btn-primary', data: {confirm: t('confirmation')})
    #  end
    #end

    class_name = document.class.to_s.downcase
    link_to "#{glyph('check')} #{t('post')}".html_safe, {controller: class_name.tableize, action: 'post', id: document.id}, method: 'put', data: {confirm: t('confirmation')}, class: 'btn btn-primary'
  end

  def button_to_unpost(document)
    #content_tag(:div, class: 'unpost_button') do
    #  form_for(document) do |f|
    #    concat hidden_field_tag("#{document.class.to_s.downcase}[status]", 0)
    #    concat button_tag("#{glyph('check-empty')} #{t('unpost')}".html_safe, type: 'submit', class: 'btn btn-primary', data: {confirm: t('confirmation')})
    #  end
    #end
    class_name = document.class.to_s.downcase
    link_to "#{glyph('check-empty')} #{t('unpost')}".html_safe, {controller: class_name.tableize, action: 'unpost', id: document.id}, method: 'put', data: {confirm: t('confirmation')}, class: 'btn btn-primary'
  end

  def button_to_update(name, document, attributes)
    class_name = document.class.to_s.downcase
    parameters = {controller: class_name.tableize, action: 'update', id: document.id, method: 'put', data: {confirm: t('confirmation')}}
    parameters[class_name.to_sym] = attributes
    button_to name, parameters, {class: 'btn btn-primary'}
  end

end
