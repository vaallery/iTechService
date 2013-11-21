# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :movement_act do
    date Time.current
    store
    association :dst_store, factory: :store
    user
  end
end
