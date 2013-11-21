# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price_type do
    sequence(:name) {|n| "Price Type #{n}"}
    kind 3

    trait :purchase do
      kind 0
    end

    trait :retail do
      kind 1
    end

  end
end
