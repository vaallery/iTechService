# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    product

    factory :featured_item do
      association :product, factory: :featured_product
    end

  end
end
