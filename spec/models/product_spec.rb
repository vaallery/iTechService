require 'spec_helper'

describe Product do

  it 'is valid with valid attributes' do
    product = build :product
    expect(product).to be_valid
  end

  it 'should return "actual_price"' do
    product = create :product
    price_type = create :price_type
    product.prices.create date: Time.current, value: '1000.0', price_type_id: price_type.id
    product.prices.create date: 1.day.ago, value: '2000.0', price_type_id: price_type.id
    expect(product.actual_price(price_type)).to eq(1000.0)
  end

    context 'feature_accounting' do

    it 'is valid with valid attributes' do
      product = create :featured_product
      expect(product).to be_valid
    end

  end

end
