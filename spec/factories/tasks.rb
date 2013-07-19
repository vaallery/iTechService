# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name "Some task"
    duration 10
    cost "9,99"
    priority 0
    location
    
    trait :important do
      priority 6
    end

  end
end
