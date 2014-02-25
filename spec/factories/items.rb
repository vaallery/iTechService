# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    product

    trait :featured do
      association :product, factory: :featured_product
    end

    trait :spare_part do
      association :product, :spare_part
    end

    factory :featured_item, traits: [:featured]

  end
end
