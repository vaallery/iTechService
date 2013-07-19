# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :device_task do
    cost 100
    done false
    comment 'comment'
    task
    device { build_stubbed(:device) }

    trait :done do
      done true
      done_at Time.now
    end
    
    trait :important do
      association :task, :important
    end

  end

end
