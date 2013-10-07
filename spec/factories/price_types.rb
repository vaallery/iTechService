# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price_type do
    sequence(:name) {|n| "Price Type #{n}"}
    kind 0

    factory :purchase_price_type do
      kind 1
    end
  end
end
