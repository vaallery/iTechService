module DeviceTypesHelper

  def nested_device_types(device_types)
    device_types.map do |device_type, sub_device_types|
      #li_class = sub_device_types.blank? ? '' : 'opened'
      ins_class = sub_device_types.any? ? 'tree_icon' : 'tree_leaf'
      #content_tag :li, content_tag(:ins, nil, class: ins_class) + render(device_type) +
      content_tag :li, render(device_type) +
          content_tag(:ul, nested_device_types(sub_device_types)), class: 'device_type opened',# + li_class,
                  id: "device_type_#{device_type.id}", device_type_id: device_type.id, title: device_type.full_name
    end.join.html_safe
  end

  #def nested_device_types(device_types, opened, form)
  #  device_types.map do |device_type, sub_device_types|
  #    li_class = opened.include?(device_type.id) ? 'opened' : 'closed'
  #    ins_class = sub_device_types.any? ? 'tree_icon' : 'tree_leaf'
  #    content_tag :li, content_tag(:ins, nil, class: ins_class) + render(device_type, form: form) +
  #        content_tag(:ul, nested_device_types(sub_device_types, opened, form)), class: 'device_type ' + li_class,
  #                id: "device_type_#{device_type.id}", device_type_id: device_type.id
  #  end.join.html_safe
  #end

  def device_types
    @device_types = DeviceType.arrange(order: :name)
  end

  def root_device_types
    @device_types = DeviceType.where(ancestry: nil)
  end

  def device_type_name_for(device_type)
    ancestors = device_type.ancestors.all.map { |t| t.name }.join ' '
    (ancestors + content_tag(:strong, ' '+device_type.name)).html_safe
  end

  def make_device_types_list(device_types, resource=nil)
    device_types.map do |device_type|
      if resource.to_s == 'order'
        content_tag :li, link_to(device_type.name, device_type_select_orders_path(device_type_id: device_type.id), remote: true)
      else
        content_tag :li, link_to(device_type.name, device_type_select_devices_path(device_type_id: device_type.id), remote: true)
      end
    end.join.html_safe
  end

end
