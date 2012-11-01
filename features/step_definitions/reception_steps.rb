Given /^a device$/ do
  @device = build :device
end

When /^I enter correct initial data$/ do
  @device = build :correct_device
end

Then /^device should get an unique ticket number$/ do
  # @device.ticket_number =
  pending 
end

Then /^device tasks should contain chosen service$/ do
  
end

Then /^device location should match chosen service$/ do
  pending # express the regexp above with the code you wish you had
end