require 'spec_helper'

describe ProductCategory do

  it 'should be valid with valid attributes' do
    product_category = build :product_category
    expect(product_category).to be_valid
  end

  #it 'should set "feature_accounting" to true if "features" present' do
  #  product = create :product, feature_accounting: true, features_attributes: { '1' => attributes_for(:feature) }
  #  expect(Feature.count).to be 1
  #  expect(product.feature_accounting).to be_true
  #end

end
