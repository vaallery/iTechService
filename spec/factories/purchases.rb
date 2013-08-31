# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    status 0
    association :contractor
    association :store
  end
end
