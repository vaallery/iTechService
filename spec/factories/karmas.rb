# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :karma do
    good false
    comment "MyText"
    user nil
  end
end
