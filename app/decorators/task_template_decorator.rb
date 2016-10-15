class TaskTemplateDecorator < ApplicationDecorator
  delegate_all
  delegate :task_templates_path, :task_template_path, to: :helpers

  def icon
    image_tag object.icon_url
  end

  def link(remote: false)
    link_to icon, object, remote: remote
  end

  def back_link(remote: false)
    _parent = object.parent
    _path = _parent.present? ? task_template_path(_parent) : task_templates_path
    link_to glyph('chevron-left'), _path, remote: remote
  end
end