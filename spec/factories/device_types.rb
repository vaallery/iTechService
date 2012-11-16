# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :device_type, aliases: [:valid_device_type] do
    sequence(:name) {|n| "Device type #{n}"}
    
    factory :invalid_device_type do
      name nil
    end
  end
end
