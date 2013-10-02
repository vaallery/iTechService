# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name 'Product 1'
    code '1'
    product_group

    factory :featured_product do
      association :product_group, factory: :featured_product_group
    end

  end
end
