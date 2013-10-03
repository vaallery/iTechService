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

      after :create do |product_category, evaluator|
        FactoryGirl.create_list :feature_type, evaluator.feature_types_count, product_category_ids: [product_category.id]
      end

    end

  end
end
