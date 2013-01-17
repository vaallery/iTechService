module AnnouncementsHelper

  def announcement_content announcement
    content = "[#{l(announcement.created_at, format: :long_d)}] #{announcement.user_name}"
    content << (announcement.content.blank? and announcement.help? ? " #{t('announcement.needs_help')}"
                : ": #{announcement.content}")
  end

  def header_link_to_help
    if current_user.needs_help?
      state_class = 'active'
      link_path = cancel_help_path
    else
      state_class = ''
      link_path = call_help_path
    end
    content_tag(:li, id: 'help_button', class: state_class) do
      link_to icon_tag('bell-alt'), link_path, method: :post, remote: true, id: 'help_link', class: state_class
      #link_to icon_tag('h-sign'), link_path, method: :post, remote: true, id: 'help_link', class: state_class
    end.html_safe
  end

  def display_announcement_for_user? announcement, user
    announcement.user_id != user.id and user.helpable?
  end

end
