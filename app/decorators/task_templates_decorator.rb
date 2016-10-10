class TaskTemplatesDecorator < Draper::CollectionDecorator
  delegate :glyph, :link_to, :new_task_template_path, :content_tag, to: :helpers

  def at(pos, editable: false, parent:)
    task_template = object.find_by position: pos
    if task_template.present?
      task_template.decorate.link remote: !editable
    elsif editable
      new_task_template_link parent, pos
    else
      link_to '', '#'
    end
  end

  def new_task_template_link(parent, position)
    params = {position: position}
    params.merge!(parent_id: parent.id) if parent.present?
    link_to glyph(:plus), new_task_template_path(params)
  end

  def back_button(parent, remote: false)
    css_class = 'back_button button span'
    if parent.present?
      image = parent.icon_url
      style = "background-image: url(#{image}); "
      content_tag :div, parent.back_link(remote: remote), class: css_class, style: style
    else
      content_tag :div, nil, class: css_class
    end
  end
end