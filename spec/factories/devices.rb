# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :device, aliases: [:valid_device] do
    ticket_number '1234567890'
    service_duration '2.30'
    device_type
    client
    location

    #before(:create) { |device| device.device_tasks.build(attributes_for(:device_task)) }
    before(:create) { |device| device.device_tasks << create_list(:device_task, 3, device: device) }

    factory :device_2 do
      association :device_type, factory: :device_type, name: "iPhone 5 16GB"
    end

    trait :with_tasks do
      ignore do
        device_tasks_count 3
      end
      
      after(:create) do |device, evaluator|
        create_list :device_task, evaluator.device_tasks_count, device: device
      end
    end
    
    trait :with_important_tasks do
      ignore do
        device_tasks_count 3
      end
      
      after(:create) do |device, evaluator|
        create_list :device_task, evaluator.device_tasks_count, :important, device: device
      end
    end
    
    trait :with_done_tasks do
      ignore do
        device_tasks_count 3
      end
      
      after(:create) do |device, evaluator|
        create_list :device_task_done, evaluator.device_tasks_count, device: device
      end
    end
  end
  
end
