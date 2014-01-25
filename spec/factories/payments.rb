# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    payment_type nil
    value "9.99"
    bank nil
  end
end
