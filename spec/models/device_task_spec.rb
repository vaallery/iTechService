require 'spec_helper'

describe DeviceTask do

  it "is valid with valid attributes" do
    device_task = build :device_task, device: build_stubbed(:device)
    device_task.should be_valid
  end
  
  it "is not valid without 'device'" do
    device_task = build :device_task, device: nil
    device_task.should_not be_valid
  end
  
  it "is not valid without 'task'" do
    device_task = build :device_task, task: nil
    device_task.should_not be_valid
  end
  
  it "should have a 'comment' attribute" do
    device_task = build :device_task
    device_task.should respond_to :comment
  end
  
  describe "associations" do
    
    before :each do
      @device_task = create :device_task
    end
    
    it "should have a 'device'" do
      @device_task.should respond_to :device
    end
    
    it "should have a 'task'" do
      @device_task.should respond_to :task
    end
    
  end

end
