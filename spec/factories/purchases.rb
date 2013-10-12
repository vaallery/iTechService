# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    status 0
    contractor
    store

    factory :purchase_with_batch do
      after(:create) do |purchase|
        purchase.batches.create attributes_for(:batch)
      end
    end

    factory :purchase_with_featured_batch do
      after(:create) do |purchase|
        purchase.batches.create attributes_for(:featured_batch)
      end
    end

  end
end
