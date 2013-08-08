# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :installment do
    installment_plan nil
    value 1
    paid_at "2013-07-30"
  end
end
