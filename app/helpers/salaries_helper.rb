module SalariesHelper

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
            content_tag(:td, link_to(icon_tag(:money), finance_user_path(user), remote: true, class: 'new_salary_link', title: t('salaries.issue')))
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
      link_to glyph(:money), '#', rel: 'popover', id: 'salary_announce_link', data: {html: true, placement: 'bottom', title: t('salaries.popover_title'), content: oncoming_salaries_list(users).gsub('\n', '')}
    end
  end

end
