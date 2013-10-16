require 'spec_helper'

describe Item do

  it 'is valid with valid attributes' do
    item = build :item
    expect(item).to be_valid
  end

  it 'should be uniq' do
    product = create :product
    create :item, product_id: product.id
    item = build :item, product_id: product.id
    expect(item).to_not be_valid
  end

  context 'feature accounting' do

    it 'is valid with valid attributes' do
      item = create :featured_item
      expect(item).to be_valid
      expect(item.feature_accounting).to be_true
    end

    it 'should not be uniq if feature accounting' do
      product = create :featured_product
      create :item, product_id: product.id
      item = build :item, product_id: product.id
      expect(item).to be_valid
    end

  end

end
