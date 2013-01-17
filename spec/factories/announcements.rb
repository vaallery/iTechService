# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
    content "MyString"
    type ""
    user nil
  end
end
