# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :client, aliases: [:valid_client] do
    name 'James Bond'
    phone_number '19294833288'
    
    factory :client_without_name do
      name nil
    end
    
    factory :client_without_phone_number do
      phone_number ''
    end
  end
  
end
