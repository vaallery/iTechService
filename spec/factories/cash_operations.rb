# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cash_operation do
    cash_shift nil
    user nil
    is_out false
    value "9.99"
  end
end
