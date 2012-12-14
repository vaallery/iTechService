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

end
