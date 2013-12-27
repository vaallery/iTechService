# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
    active true
    kind 'help'
    content 'Content'
    user nil
  end
end
