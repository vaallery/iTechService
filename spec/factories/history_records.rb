# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :history_record do
    user nil
    object nil
    column_name "MyString"
    column_type "MyString"
    old_value "MyString"
    new_value "MyString"
    deleted_at "2012-11-22 16:48:53"
  end
end
