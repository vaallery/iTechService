# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    sequence(:code)
    product_group

    factory :featured_product do
      association :product_group, factory: :featured_product_group
    end

  end
end
