# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name 'Some task'
    duration 0
    cost 0
    priority 0
    location
    product
    trait(:repair) { role 'technician' }
    trait(:important) { priority 6 }
  end
end
