# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_characteristic do
    client_category
    comment "Comment"
  end
end
