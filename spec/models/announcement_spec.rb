require 'spec_helper'

describe Announcement do

  context 'with valid attributes' do

    it "should have 'recipients' if 'kind' is 'device_return'" do
      users = create_list :user, 3
      announcement = create :announcement, kind: 'device_return', user: users.first, recipient_ids: users.map{ |u| u.id }
      expect(announcement.recipients.count).to be 3
    end

    it "should exclude 'recipient'" do
      users = create_list :user, 3
      user = users.first
      announcement = create :announcement, kind: 'device_return', recipient_ids: users.map { |u| u.id }
      announcement.exclude_recipient user
      expect(announcement.recipients).to_not include(user)
      expect(user).to_not be_nil
    end

    it "should change 'active' to false if no recipients left" do
      user = create :user
      announcement = create :announcement, kind: 'device_return', recipient_ids: [user.id]
      announcement.exclude_recipient user
      expect(announcement.active).to be false
    end

  end

end
