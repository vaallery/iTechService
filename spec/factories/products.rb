# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name 'Product 1'
    code '1'
    product_group
    #feature_accounting false
    #association :category
    #association :group, factory: :device_type

    trait :with_feature do
      ignore do
        features_count 1
      end

      after(:create) do |product, evaluator|
        create_list :feature, evaluator.features_count, product: product
      end
    end
  end
end
