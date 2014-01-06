# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :movement_item do
    movement_act
    item
    quantity 1
  end
end
