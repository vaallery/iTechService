# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_price do
    product
    price_type
    date Time.current
    value '1000'
  end
end
