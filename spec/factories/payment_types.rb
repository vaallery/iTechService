# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_type do
    name 'Cash'
    kind 0
  end
end
