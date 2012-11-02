require 'spec_helper'

describe User do
  
  it "is valid with valid attributes" do
    user = create :user
    user.should be_valid
  end
  
  it "is not valid without 'username'" do
    user = build :user_without_username
    user.should_not be_valid
  end
  
end
