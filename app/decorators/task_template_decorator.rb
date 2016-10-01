class TaskTemplateDecorator < ApplicationDecorator
  delegate_all

  def icon
    image_tag object.icon.url
  end

  def link
    link_to icon, object
  end
end