# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :devices_task, :class => 'DevicesTasks' do
    device nil
    task nil
    done false
  end
end
