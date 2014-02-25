# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repair_group do
    sequence(:name) { |n| "Repair group #{n}" }
    ancestry nil
  end
end
