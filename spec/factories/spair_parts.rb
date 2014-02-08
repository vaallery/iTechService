# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :spair_part do
    repair_service nil
    item nil
    quantity 1
    warranty_term 1
  end
end
