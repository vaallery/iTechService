# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_group do
    name "Product group"
    ancestry nil
    is_service false
    request_price false
    product_category
  end
end
