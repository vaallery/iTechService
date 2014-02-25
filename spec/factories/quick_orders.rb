# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quick_order do
    number 1
    user nil
    client_name "MyString"
    contact_phone "MyString"
    comment "MyText"
  end
end
