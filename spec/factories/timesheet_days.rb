# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timesheet_day do
    date '2013-07-01'
    user
    status 'presence'
    work_mins 480
    time '23:07'
  end
end
