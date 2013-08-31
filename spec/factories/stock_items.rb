# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stock_item do
    item ""
    store nil
    quantity 1
  end
end
