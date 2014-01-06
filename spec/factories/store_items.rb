# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :store_item do
    item
    store
    quantity 0
  end

  trait :featured do
    association :item, factory: :featured_item
  end

end
