class TaskTemplateDecorator < ApplicationDecorator
  delegate_all
  delegate :task_templates_path, to: :helpers

  def icon
    image_tag object.icon_url
  end

  def link(remote: false)
    link_to icon, object, remote: remote
  end

  def back_link(remote: false)
    link_to glyph('chevron-left'), task_templates_path, remote: remote
  end
end