# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repair_service do
    repair_group nil
    name "MyString"
    price "9.99"
  end
end
