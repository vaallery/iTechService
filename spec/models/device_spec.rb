require 'spec_helper'

describe Device do
  
  it "is valid with valid attributes" do
    device = create :device
    device.should be_valid
  end
  
  it "is not valid without device type" do
    device = build :device_without_device_type
    device.should_not be_valid
  end
  
  it "is not valid without a client" do
    device = build :device_without_client
    device.should_not be_valid
  end
  
  it 'is not valid without ticket number' do
    device = build :device_without_ticket_number
    device.should_not be_valid
  end
  
  it 'is not valid with blank ticket_number' do
    device = build :device_with_blank_ticket_number
    device.should_not be_valid
  end
  
  it 'should have unique ticket number' do
    device1 = create :valid_device
    device = build :valid_device
    device.should_not be_valid
  end
  
  describe "associations" do
    
    before :each do
      @device = create :device
    end
    
    it "should have a 'client' attribute" do
      @device.should respond_to :client
    end
    
    it "should have a 'device_type' attributes" do
      @device.should respond_to :device_type
    end
    
    it "should have a 'client_name' attribute" do
      @device.should respond_to :client_name
    end
    
    it "should have a 'type_name' attribute" do
      @device.should respond_to :type_name
    end
    
    it "should have a 'tasks' attribute" do
      @device.should respond_to :tasks
    end
    
    describe "attribute 'client_name'" do
      
      it "should be equal to 'client_type.name'" do
        @device.client_name.should eq @device.client.name
      end
      
    end
    
    describe "attribute 'type_name'" do
      
      it "should be equal to 'device_type.name'" do
        @device.type_name.should eq @device.device_type.name
      end
      
    end
    
  end
  
end
