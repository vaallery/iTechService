class Announcement < ActiveRecord::Base
  KINDS = %w[help coffee for_coffee protector info birthday order_status order_done salary device_return]

  belongs_to :user
  has_and_belongs_to_many :recipients, class_name: 'User'#, association_foreign_key: 'recipient_ids'
  attr_accessible :content, :kind, :user_id, :user, :active, :recipient_ids
  validates :kind, presence: true
  validates :kind, inclusion: { in: KINDS }
  scope :newest, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :active, where(active: true)
  scope :active_help, where(active: true, kind: 'help')
  scope :active_coffee, where(active: true, kind: 'coffee')
  scope :active_protector, where(active: true, kind: 'protector')
  scope :active_birthdays, where(active: true, kind: 'birthday')
  scope :device_return, where(kind: 'device_return')

  after_initialize do |announcement|
    announcement.kind ||= 'info'
  end

  def user_name
    user.present? ? user.short_name : '-'
  end

  def help?
    kind == 'help'
  end

  def coffee?
    kind == 'coffee'
  end

  def for_coffee?
    kind == 'for_coffee'
  end

  def protector?
    kind == 'protector'
  end

  def birthday?
    kind == 'birthday'
  end

  def order_status?
    kind == 'order_status'
  end

  def order_done?
    kind == 'order_done'
  end

  def salary?
    kind == 'salary'
  end

  def device_return?
    kind == 'device_return'
  end

  def device
    Device.find(content.to_i)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def visible_for?(user)
    return (user_id != user.id and user.software?) if help?
    return user.software? if coffee?
    return user.media? if for_coffee?
    return user.software? if protector?
    return user.admin? if birthday?
    return user_id == user.id if order_status?
    return (user_id == user.id or user.media?) if order_done?
    return recipient_ids.include?(user.id) if device_return?
    false
  end

  def exclude_recipient(recipient)
    self.recipients.destroy recipient
    self.update_attribute :active, false if self.recipients.blank?
  end

end
