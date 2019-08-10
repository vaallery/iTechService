module SalariesHelper

  def oncoming_salaries_list(users)
    if users.any?
      today = Date.current
      content_tag(:table, id: 'oncoming_salaries_list', class: 'table table-condensed table-hover') do
        users.map do |user|
          content_tag(:tr) do
            time_text = if user.upcoming_salary_date.today?
                          text = 'Отработал(а)'
                          years, months = ((Time.now - user.hiring_date.to_time) / 1.month).divmod(12)

                          if years > 0
                            text << " #{years}"
                            text << if years == 1 || (years > 20 && years.modulo(10) == 1)
                                      ' год'
                                    elsif (years < 5 || years > 20) && years.modulo(10).in?(2..4)
                                      ' года'
                                    else
                                      ' лет'
                                    end
                          end

                          months = months.to_i
                          if months > 0
                            text << " #{months} мес."
                          end

                          text
                        else
                          "#{t(:in_time)} #{distance_of_time_in_words(today, user.upcoming_salary_date)}"
                        end
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
    # content_tag(:span, id: 'salary_announce', class: notify_class) do
      link_to glyph(:money), '#', rel: 'popover', class: notify_class, id: 'salary_announce', data: {html: true, placement: 'bottom', title: t('salaries.popover_title'), content: oncoming_salaries_list(users).gsub('\n', '')}
    # end
  end

end
