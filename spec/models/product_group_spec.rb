require 'spec_helper'

describe ProductGroup do

  it 'should be valid with valid attributes' do
    product_group = build :product_group
    expect(product_group).to be_valid
  end

end
