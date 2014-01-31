# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :top_salable do
    salable nil
    position 1
    color "MyString"
  end
end
