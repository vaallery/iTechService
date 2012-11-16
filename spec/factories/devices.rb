# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :device, aliases: [:valid_device] do
    device_type
    client
    
    factory :device_2 do
      association :device_type, factory: :device_type, name: "iPhone 5 16GB"
    end
    
    factory :invalid_device do
      device_type nil
      ticket_number nil
      client nil
    end
    
    factory :device_without_device_type do
      device_type nil
    end
    
    factory :device_without_client do
      client nil
    end
    
    factory :device_without_ticket_number do
      ticket_number ''
    end
    
    factory :device_with_pending_tasks do
      ignore do
        device_tasks_count 5
      end
      
      after(:create) do |device, evaluator|
        create_list :device_task, evaluator.device_tasks_count, device: device
      end
    end
    
    factory :device_with_important_tasks do
      ignore do
        device_tasks_count 5
      end
      
      after(:create) do |device, evaluator|
        create_list :device_task, evaluator.device_tasks_count, :important, device: device
      end
    end
    
    factory :device_with_done_tasks do
      ignore do
        device_tasks_count 5
      end
      
      after(:create) do |device, evaluator|
        create_list :device_task_done, evaluator.device_tasks_count, device: device
      end
    end
  end
  
end
