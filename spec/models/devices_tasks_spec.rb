require 'spec_helper'

describe DevicesTasks do
  it "is valid with valid attributes" do
    devices_task = build :devices_task
    devices_task.should be_valid
  end
  
  it "is not valid without 'device'" do
    devices_task = build :devices_task_without_device
    devices_task.should_not be_valid
  end
  
  it "is not valid without 'task'" do
    devices_task = build :devices_task_without_task
    devices_task.should_not be_valid
  end
  
  describe "associations" do
    
    before :each do
      @devices_task = create :devices_task
    end
    
    it "should have a 'device'" do
      @devices_task.should respond_to :device
    end
    
    it "should have a 'task'" do
      @devices_task.should respond_to :task
    end
    
  end
end
