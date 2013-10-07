# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature_type do
    sequence(:name) { |n| "Feature Type #{n}" }
    sequence(:code) { |n| "feature_type_#{n}" }
  end
end
