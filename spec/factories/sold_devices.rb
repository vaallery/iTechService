# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sale do
    device_type nil
    imei "MyString"
    serial_number "MyString"
    sold_at "2013-03-06 21:00:59"
  end
end
