class ScheduleDay < ActiveRecord::Base
  attr_accessible :day, :hours

  default_scope order('day asc')
end
