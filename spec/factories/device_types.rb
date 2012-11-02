# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :device_type, aliases: [:valid_device_type] do
    name 'iPhone 5 64GB'
    
    factory :invalid_device_type do
      name nil
    end
  end
  
end
