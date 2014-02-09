# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repair_part do
    repair_task nil
    item nil
    warranty_term 1
    defect_qty 1
  end
end
