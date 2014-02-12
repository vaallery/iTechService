# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repair_part do
    repair_task
    item
    warranty_term 0
    defect_qty 0
  end
end
