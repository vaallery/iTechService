# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :revaluation_act do
    price_type
    date Time.current

    after(:create) do |revaluation_act|
      revaluation_act.revaluations.create product_id: create(:product).id, price: '1000'
    end
  end
end
