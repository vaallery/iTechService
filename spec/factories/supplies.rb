# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :supply do
    supply_report nil
    supply_category nil
    name ""
    quantity 1
    cost "9.99"
  end
end
