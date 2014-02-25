# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :revaluation do
    revaluation_act
    product
    price '10000'
  end
end
