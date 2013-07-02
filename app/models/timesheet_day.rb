class TimesheetDay < ActiveRecord::Base
  belongs_to :user
  attr_accessible :appearance, :date, :status, :work_mins
end
