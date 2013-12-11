# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bonus do
    bonus_type
    comment 'Comment'
  end
end
