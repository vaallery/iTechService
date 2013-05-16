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
                content_tag(:td, link_to(icon_tag(:money), new_salary_path(user_id: user), class: 'new_salary_link',
                                         title: t('salaries.issue')))
          end
        end.join.html_safe
      end.html_safe
    else
      ''
    end
  end

end
