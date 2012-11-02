require 'spec_helper'

describe DeviceType do
  
  it "is valid with valid attributes" do
    device_type = build :valid_device_type
    device_type.should be_valid
  end
  
  it "is not valid without name" do
    device_type = build :invalid_device_type
    device_type.should_not be_valid
  end
  
end
