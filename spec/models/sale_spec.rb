require 'spec_helper'

describe Sale do

  it 'is valid with valid attributes' do
    sale = create :sale
    expect(sale).to be_valid
  end

end
