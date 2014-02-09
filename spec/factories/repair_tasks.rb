# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repair_task do
    repair_service nil
    device_task nil
    price "9.99"
  end
end
