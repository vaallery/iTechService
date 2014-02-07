module RepairGroupsHelper

  def repair_groups_trees_tag(repair_groups, current_id=nil, options={})
    repair_groups.map do |repair_group|
      repair_groups_tree_tag repair_group, current_id, options
    end.join.html_safe
  end

  def repair_groups_tree_tag(repair_group, current_id=nil, options={})
    content_tag :ul, nested_repair_groups_list(repair_group.subtree.arrange, current_id, options), class: 'repair_groups_tree unstyled', id: "repair_groups_tree_#{repair_group.id}", data: {root_id: repair_group.id, repair_group_id: current_id}
  end

  def nested_repair_groups_list(repair_groups, current_id=nil, options={})
    repair_groups.map do |repair_group, sub_repair_groups|
      is_current = repair_group.id == current_id
      li_class = 'opened'
      li_class << ' current' if is_current
      content_tag :li, link_to(repair_group.name, repair_group_path(repair_group, options), remote: true) + content_tag(:ul, nested_repair_groups_list(sub_repair_groups, current_id, options)), class: "repair_group #{li_class}", id: "repair_group_#{repair_group.id}", title: repair_group.name, data: {repair_group_id: repair_group.id}
    end.join.html_safe
  end

end
