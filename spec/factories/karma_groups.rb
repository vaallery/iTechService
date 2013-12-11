# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :karma_group do

    trait :with_bonus do
      bonus
    end

  end
end
