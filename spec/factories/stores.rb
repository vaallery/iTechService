# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    sequence(:name) {|n| "Store #{n}"}

    after(:create) do |store|
      store.update_attribute :price_type_ids, [create(:price_type).id]
    end
  end
end
