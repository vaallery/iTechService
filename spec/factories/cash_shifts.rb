# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cash_shift do
    is_closed false
    closer nil
  end
end
