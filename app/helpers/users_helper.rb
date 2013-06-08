module UsersHelper

  def user_row_tag(user)
    content_tag(:tr, id: "user_row_#{user.id}", class: 'user_row') do
      content_tag(:td, link_to(user.id, user_path(user))) +
      content_tag(:td, link_to(user.username, user_path(user))) +
      content_tag(:td) do
        link_to(user.short_name, user_path(user)) + ' ' +
        karma_tag(user)
      end +
      content_tag(:td, t("users.roles.#{user.role}")) +
      content_tag(:td, user.location_name(true)) +
      content_tag(:td, l(user.created_at, format: :long_d)) +
      content_tag(:td) do
        content_tag(:div, class: 'btn-group') do
          link_to_add_karma(user, true, class: 'btn btn-small') +
          link_to_add_karma(user, false, class: 'btn btn-small')
        end +
        content_tag(:div, class: 'btn-group') do
          content = link_to_show_small(user)
          content += link_to_edit_small(user) if can? :edit, user
          content
        end
      end
    end.html_safe
  end

  def schedule_hour_class_for(user, day, hour)
    schedule_hour_class = ''
    if (schedule_day = user.schedule_days.find_by_day day).present?
      unless schedule_day.hours.blank?
        hours = schedule_day.hours.split ','
        schedule_hour_class = 'work_hour' if hours.include? hour.to_s
      end
    end
    schedule_hour_class
  end

  def hour_attributes_for(user, day, hour)
    color = 'inherit'
    hour_class = 'job_schedule_user_hour'
    user_id = ''
    if user.present? and (schedule_day = user.schedule_days.find_by_day day).present?
      user_id = user.id
      unless schedule_day.hours.blank?
        hours = schedule_day.hours.split ','
        if hours.include? hour.to_s
          color = user.color_s
          hour_class << ' work_hour'
        end
      end
    end
    {style: "background-color: #{color}", class: hour_class, data: {hour: hour}, title: user.short_name}
  end

  def hours_attributes_for(user, day, day_id=nil)
    color = user.try(:color_s) || 'inherit'
    user_id = user.try(:id) || ''
    day_id ||= user.present? ? user.schedule_days.find_by_day(day).try(:id) : ''
    {class: 'job_schedule_user_hours', data: {user: user_id, day: day, dayid: day_id, color: color}}
  end

  def user_hours_row_tag(day, user=nil, day_id=nil)
    content_tag(:tr, hours_attributes_for(user, day, day_id)) do
      (10..20).collect do |hour|
        tag(:td, hour_attributes_for(user, day, hour))
      end.join.html_safe +
      content_tag(:td, class: 'job_schedule_hours_actions') do
        link_to(icon_tag('ok-sign'), '#', remote: true, class: 'save_job_schedule_hours pull-left') +
        link_to(icon_tag('remove-sign'), '#', remote: true, class: 'delete_job_schedule_hours pull-right')
      end.html_safe
    end.html_safe
  end

  def link_to_add_user_hours(day)
    link_to icon_tag('plus-sign'), '#', remote: true, class: 'add_user_to_job_schedule', data: {day: day}
  end

  def duty_day_cell(day, month)
    content_tag(:td, duty_day_attributes(day, month)) do
      if day.today?
        content_tag :span, day.day, class: 'badge badge-info'
      else
        content_tag :span, day.day, class: 'badge badge-blank'
      end
    end.html_safe
  end

  def duty_day_attributes(day, month)
    day_class = ''
    day_class = 'today' if day.today?
    day_class << (day.month == month ? ' calendar_day' : ' muted')
    day_color = 'inherit'
    day_id = ''
    style = ''
    duty_day = DutyDay.find_by_day day
    if duty_day.present? and (duty_user = duty_day.user).present?
      day_id = duty_day.id
      day_color = duty_user.color
      day_class << ' duty'
      style = "background-color: #{day_color}" if day_class.include? 'calendar_day'
    else
      day_class << ' empty'
    end
    {class: day_class, data: {user: duty_user.try(:id) || '', dayid: day_id, day: day.to_s, color: day_color},
     style: style, title: duty_user.try(:short_name)}
  end

  def calendar_month_days(date)
    start_day = date.beginning_of_month.beginning_of_week
    end_day = date.end_of_month.end_of_week
    (start_day..end_day).to_a
  end

  def calendar_day_class(user, day, month)
    day_class = ''
    day_class << 'today' if day.today?
    day_class << ' work_day' if user.is_work_day? day
    day_class << ' shortened' if user.is_shortened_day? day
    day_class << ' duty' if user.is_duty_day? day
    #day_class << (is_other_duty?(user, day) ? ' other_duty' : ' empty')
    if is_other_duty? user, day
      day_class << ' other_duty'
    else
      day_class << ' empty' if can? :manage, user
    end
    day_class << (day.month == month ? ' calendar_day' : ' muted')
  end

  def next_other_duties(user, date)
    DutyDay.where('user_id <> ? AND day > ?', user.id, date).reorder('day asc')
  end

  def next_duties(date)
    DutyDay.where('day >= ?', date).reorder('day asc')
  end

  def profile_link
    icon_class = current_user.any_admin? ? 'user-md' : 'user'
    link_to icon_tag(icon_class) + current_user.username, profile_path, id: 'profile_link',
            data: {id: current_user.id, helpable: current_user.helpable?,
                   location: current_user.location_id, role: current_user.role}
  end

  def karma_tag(user)
    badge_class = 'badge'
    good_count = user.karmas.good.count
    bad_count = user.karmas.bad.count
    if good_count > 0 or bad_count > 0
      diff = good_count - bad_count
      badge_class << ' badge-success' if diff > 1
      badge_class << ' badge-important' if diff < -1
      badge_class << ' badge-warning' if diff.between? -1, 1
    end
    content_tag :span, "#{good_count} / #{bad_count}", class: badge_class
  end

  def duty_info_tag
    content_tag :div, id: 'duty_info', class: 'alert alert-block' do
      content_tag :h4, t('users.duty_info')
    end
  end

  def accessible_roles
    current_user.superadmin? ? User::ROLES : User::ROLES_FOR_ADMIN
  end

  private

  def is_other_duty?(user, date)
    DutyDay.duties_except_user(user).exists?(day: date)
  end

end
