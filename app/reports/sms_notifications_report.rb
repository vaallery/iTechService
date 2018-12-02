class SmsNotificationsReport < BaseReport
  def call
    sms_notifications = Service::SMSNotification.includes(:sender).where(sent_at: period)
    sms_notifications.find_each do |sms_notification|
      sender_id = sms_notification.sender_id
      sender_name = sms_notification.sender.short_name

      sms_notification_data = {
        phone_number: sms_notification.phone_number,
        message: sms_notification.message,
        sent_at: sms_notification.sent_at
      }

      if result.key? sender_id
        result[sender_id][:qty] = result[sender_id][:qty] + 1
        result[sender_id][:sms_notifications] << sms_notification_data
      else
        result[sender_id] = {sender_name: sender_name, qty: 1, sms_notifications: [sms_notification_data]}
      end
    end

    result
  end
end
