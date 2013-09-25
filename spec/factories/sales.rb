# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sale do
    sold_at Time.current
    user
    client
    store
    payment_type
  end
end
