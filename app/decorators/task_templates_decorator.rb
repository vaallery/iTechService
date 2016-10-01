class TaskTemplatesDecorator < Draper::CollectionDecorator
  delegate :glyph, :link_to, :new_task_template_path, to: :helpers

  def at(row, col, editable: false, parent:)
    pos = col + 1 + row * 10
    task_template = object.find_by position: pos
    if task_template.present?
      task_template.decorate.link
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
end