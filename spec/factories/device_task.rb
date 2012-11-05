# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device_task, :class => 'DeviceTask' do
    device
    task
    done false
    comment 'comment'
    
    factory :device_task_without_device do
      device nil
    end
    
    factory :device_task_without_task do
      task nil
    end
  end
end
