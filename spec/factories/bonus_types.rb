# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bonus_type do
    sequence(:name) { |n| "Bonus type #{n}" }
  end
end
