# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature do
    feature_type
    product
    value 'feature value'
  end
end
