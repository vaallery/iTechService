# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :device, aliases: [:wrong_device] do
    device_type nil
    ticket_number "3478926"
    
    factory :correct_device do
      association :device_type
    end
  end
  
end
