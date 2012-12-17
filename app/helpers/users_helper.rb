module UsersHelper

  def schedule_hour_class_for user, day, hour
    schedule_hour_class = ''
    if (schedule_day = user.schedule_days.find_by_day day).present?
      unless schedule_day.hours.blank?
        hours = schedule_day.hours.split ','
        schedule_hour_class = 'work_hour' if hours.include? hour.to_s
      end
    end
    schedule_hour_class
  end

  def calendar_month_days date
    start_day = date.beginning_of_month.beginning_of_week
    end_day = date.end_of_month.end_of_week
    (start_day..end_day).to_a
    #(start_day..end_day).map {|d|d.day}
  end

  def calendar_day_class user, day, month
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

  def next_other_duties user, date
    DutyDay.where('user_id <> ? AND day > ?', user.id, date).reorder('day asc')
  end

  private

  def is_other_duty? user, date
    DutyDay.duties_except_user(user).exists?(day: date)
  end

end
