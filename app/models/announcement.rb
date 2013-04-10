class Announcement < ActiveRecord::Base
  KINDS = %w[help coffee for_coffee protector info birthday order_status order_done salary]

  belongs_to :user
  attr_accessible :content, :kind, :user_id, :active
  validates :kind, :user_id, presence: true
  scope :newest, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :active, where(active: true)
  scope :active_help, where(active: true, kind: 'help')
  scope :active_coffee, where(active: true, kind: 'coffee')
  scope :active_protector, where(active: true, kind: 'protector')
  scope :active_birthdays, where(active: true, kind: 'birthday')

  after_initialize do |announcement|
    announcement.kind ||= 'info'
  end

  def user_name
    user.short_name
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

  def visible_for?(user)
    return (user_id != user.id and user.software?) if help?
    return user.software? if coffee?
    return user.media? if for_coffee?
    return user.software? if protector?
    return user.admin? if birthday?
    return user_id == user.id if order_status?
    return (user_id == user.id or user.media?) if order_done?
    false
  end

  def closeable_by?(user)
    (order_done? or order_status?) and (user_id == user.id)
  end

end
