# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timesheet_day do
    date "2013-07-01"
    user nil
    status "MyString"
    work_mins 1
    appearance "2013-07-01 23:07:40"
  end
end
