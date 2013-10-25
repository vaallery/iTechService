# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_group do
    name 'Product group 1'
    ancestry nil
    is_service false
    request_price false
    product_category

    factory :service_product_group do
      is_service true
    end

    factory :featured_product_group do
      association :product_category, factory: :featured_product_category
    end
  end
end
