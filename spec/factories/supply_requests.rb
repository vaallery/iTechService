# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :supply_request do
    user nil
    status "MyString"
  end
end
