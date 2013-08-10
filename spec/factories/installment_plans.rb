# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :installment_plan do
    user nil
    object "MyString"
    cost 1
    issued_at "2013-07-30"
  end
end
