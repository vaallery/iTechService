# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repair_task do
    repair_service
    device_task
    price 1000.0
  end
end
