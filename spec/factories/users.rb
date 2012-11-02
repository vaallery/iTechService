# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username "username"
    role "staff"
    
    factory :user_without_username do
      username nil
    end
  end
end
