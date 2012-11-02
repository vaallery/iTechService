# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name "Some task"
    duration 10
    cost "9.99"
    
    factory :task_without_name do
      name nil
    end
  end
end
