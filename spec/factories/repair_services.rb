# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repair_service do
    repair_group
    sequence(:name) { |n| "Repair service #{n}" }
    price 1000.0
  end
end
