# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :batch do
    purchase nil
    product nil
    price "9.99"
    quantity 1
  end
end
