# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "User #{n}" }
    role 'software'
    password 'password'


    factory :user_without_username do
      username nil
    end
    
    factory :user_without_password do
      password nil
    end
  end
  
  factory :admin, class: User do
    username 'Admin'
    role 'admin'
  end
  
  factory :technician, class: User do
    username 'Technician'
    role 'technician'
  end
end
