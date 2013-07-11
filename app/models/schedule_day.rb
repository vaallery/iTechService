class ScheduleDay < ActiveRecord::Base

  belongs_to :user

  attr_accessible :day, :hours, :user, :user_id

  default_scope order('day asc')

  def hours_array
    hours.present? ? hours.split(',') : []
  end

  def begin_of_work(date=nil)
    date ||= Time.now
    if hours_array.any?
      date.change hour: hours_array.first.to_i
    else
      nil
    end
  end

  def end_of_work(date=nil)
    date ||= Time.now
    if hours_array.any?
      date.change hour: hours_array.last.to_i
    else
      nil
    end
  end

end
