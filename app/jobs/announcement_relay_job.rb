class AnnouncementRelayJob < ActiveJob::Base
  queue_as :no_retry

  def perform(announcement_id)
    PrivatePub.publish_to '/announcements', "$.getScript('/announcements/#{announcement_id}');"
  end
end