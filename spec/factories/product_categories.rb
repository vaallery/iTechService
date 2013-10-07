# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_category do
    name 'Category 1'
    feature_accounting false

    factory :featured_product_category do
      feature_accounting true

      ignore do
        feature_types_count 1
      end

      after(:create) do |product_category, evaluator|
        product_category.update_attribute :feature_type_ids, [create(:feature_type).id]
      end

    end

  end
end
