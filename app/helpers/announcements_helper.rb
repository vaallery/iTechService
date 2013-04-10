module AnnouncementsHelper

  def announcement_content announcement
    case announcement.kind
      when 'help' then text = " #{t('announcements.needs_help')}"
      when 'coffee' then text = ": #{t('announcements.coffee_made')}"
      when 'for_coffee' then text = ": #{t('announcements.coffee_order', content: announcement.content)}"
      when 'protector' then text = ": #{t('announcements.protector_made')}"
      when 'birthday'
        text = ''
        if (birthday = announcement.user.birthday).present?
          text = t('announcements.birthday', user: announcement.user.short_name, time: l(birthday, format: :short))
        end
      when 'order_status' then text = "[#{l(announcement.created_at, format: :long_d)}] #{announcement.content}"
      when 'order_done' then text = "[#{l(announcement.created_at, format: :long_d)}] #{announcement.content}"
      else text = ": #{announcement.content}"
    end
    if announcement.birthday? or announcement.order_status? or announcement.order_done?
      text
    else
      "[#{l(announcement.created_at, format: :long_d)}] #{announcement.user.short_name}" + text
    end
  end

  def header_link_to_announce
    case current_user.role
      when 'software' then icon = 'bell-alt'; kind = 'help'
      when 'media' then icon = 'coffee'; kind = 'coffee'
      when 'technician' then icon = 'file'; kind = 'protector'
      else return nil
    end
    if current_user.announced?
      state_class = 'active'
      link_path = cancel_announce_path(kind: kind)
    else
      state_class = ''
      link_path = make_announce_path(kind: kind)
    end
    content_tag(:li, id: 'announce_button', class: state_class) do
      link_to icon_tag(icon), link_path, method: :post, remote: true, id: 'announce_link', class: state_class
    end.html_safe
  end

  def header_link_for_coffee
    if current_user.software?
      coffee_order_form = form_tag(make_announce_path, remote: true, id: 'coffee_order_form', class: 'form-inline') do
        content_tag(:div, class: 'input-append') do
          hidden_field_tag(:kind, 'for_coffee') +
          text_field_tag(:content, nil, class: 'input-medium', autofocus: true) +
          submit_tag('OK', class: 'btn btn-primary')
        end +
        link_to(t('announcements.close_orders'), cancel_announce_path(kind: 'for_coffee'), method: :post, remote: true,
                class: 'btn btn-small')
      end.gsub('\n', '')

      content_tag(:li, id: 'coffee_order_button') do
        link_to icon_tag('coffee'), '#', remote: true, id: 'coffer_order_link',
                data: {html: true, placement: 'bottom', title: t('announcements.coffee_order_popover_title'),
                content: coffee_order_form}
      end
    else
      nil
    end
  end

  def oncoming_salaries_list(users)
    if users.any?
      today = Date.current
      content_tag(:table, id: 'oncoming_salaries_list', class: 'table table-condensed table-hover') do
        users.map do |user|
          content_tag(:tr) do
            time_text = user.upcoming_salary_date.today? ? t(:today)
                            : "#{t(:in_time)} #{distance_of_time_in_words(today, user.upcoming_salary_date)}"
            content_tag(:td, time_text) +
            content_tag(:td, link_to(user.short_name, user_path(user))) +
            content_tag(:td, link_to(icon_tag(:money), new_salary_path(user_id: user), class: 'new_salary_link',
                title: t('salaries.issue')))
          end
        end.join.html_safe
      end.html_safe
    else
      ''
    end
  end

  def header_link_to_salaries
    users = User.oncoming_salary
    notify_class = users.any? ? 'notify' : ''
    content_tag(:li, id: 'salary_announce', class: notify_class) do
      link_to icon_tag(:money), '#', remote: true, id: 'salary_announce_link', data: {html: true, placement: 'bottom',
          title: t('salaries.popover_title'), content: oncoming_salaries_list(users).gsub('\n', '')}
    end
  end

end
