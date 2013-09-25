require 'spec_helper'

describe Product do

  it 'is valid with valid attributes' do
    product = build :product
    expect(product).to be_valid
  end

end
