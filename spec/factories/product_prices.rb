# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_price do
    product nil
    price nil
    date "2013-09-18"
  end
end
