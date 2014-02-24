# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store_product do
    store nil
    product nil
    warning_quantity 1
  end
end
