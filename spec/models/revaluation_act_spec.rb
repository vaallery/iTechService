require 'spec_helper'

describe RevaluationAct do

  it 'is valid with valid attributes' do
    revaluation_act = build :revaluation_act
    expect(revaluation_act).to be_valid
  end

  it 'has revaluations' do
    revaluation_act = create :revaluation_act
    expect(revaluation_act.revaluations.count).to be > 0
  end

  context 'posting' do

    it 'should create "product_prices"' do
      revaluation_act = create :revaluation_act
      revaluation_act.post
      product = revaluation_act.revaluations.first.product
      actual_price = product.actual_price(revaluation_act.price_type)
      expect(actual_price).to eq(revaluation_act.revaluations.first.price)
    end

  end

end
