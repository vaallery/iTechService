# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gift_certificate do
    number "MyString"
    nominal 1
    status 1
  end
end
