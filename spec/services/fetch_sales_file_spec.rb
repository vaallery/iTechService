require 'rails_helper'

describe FetchSalesFile do
  it 'returns sales file' do
    file = FetchSalesFile.call
    expect(file).not_to be_nil
  end
end
