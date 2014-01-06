# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :batch do
    purchase
    item
    price '1000'
    quantity 1

    factory :featured_batch do
      association(:item, factory: :featured_item)
    end

  end
end
