# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :devices_task, :class => 'DevicesTasks' do
    device
    task
    done false
    
    factory :devices_task_without_device do
      device nil
    end
    
    factory :devices_task_without_task do
      task nil
    end
  end
end
