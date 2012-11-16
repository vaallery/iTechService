# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device_task, :class => 'DeviceTask' do
    device
    task
    cost 100
    done false
    done_at nil
    comment 'comment'
    
    trait :done do
      done true
      done_at Time.now
    end
    
    trait :important do
      association :task, :important
    end
    
    factory :device_task_without_device do
      device nil
    end
    
    factory :device_task_without_task do
      task nil
    end
    
  end
end
