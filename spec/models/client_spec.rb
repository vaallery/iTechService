require 'spec_helper'

describe Client do
  
  it 'is valid with valid attributes' do
    client = build :client
    expect(client).to be_valid
  end
  
  it 'is not valid without "name"' do
    client = build :client_without_name
    client.should_not be_valid
  end
  
  it 'is not valid without "phone number"' do
    client = build :client_without_phone_number
    client.should_not be_valid
  end
  
  describe 'associations' do
    
    it 'should have "devices" attribute' do
      client = create :client
      client.should respond_to :devices
    end
    
  end
  
end
