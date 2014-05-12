class Announcement < ActiveRecord::Base
  KINDS = %w[help coffee for_coffee protector info birthday order_status order_done salary device_return]

  belongs_to :user, inverse_of: :announcements
  has_and_belongs_to_many :recipients, class_name: 'User', join_table: 'announcements_users', uniq: true
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
  scope :actual_for, lambda { |user| active.keep_if { |announcement| announcement.visible_for? user } }

  before_create :define_recipients

  after_initialize do
    kind ||= 'info'
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
    if self.device_return? and user.technician?
      if self.device.present?
        self.device.location.is_repair?
      else
        self.destroy
        return false
      end
    else
      self.recipient_ids.include?(user.id)
      #case kind
      #  when 'help' then is_recipient or (user_id != user.id and user.software?)
      #  when 'coffee' then is_recipient or user.software?
      #  when 'for_coffee' then is_recipient or user.media?
      #  when 'protector' then is_recipient or user.software?
      #  when 'birthday' then is_recipient or user.any_admin?
      #  when 'order_status' then is_recipient or user_id == user.id
      #  when 'order_done' then is_recipient or user_id == user.id or user.media?
      #  when 'device_return' then is_recipient and !(self.device.at_done? or self.device.in_archive?)
      #  else is_recipient
      #end
    end
  end

  def exclude_recipient(recipient)
    self.recipients.destroy recipient
    self.update_attribute(:active, false) if self.recipients.blank?
  end

  private

  def define_recipients
    recipients = []
    case self.kind
      when 'help'
        recipients = User.software.exclude(User.current).to_a
      when 'coffee'
        recipients = User.software.to_a
      when 'for_coffee'
        recipients = User.media.to_a
      when 'protector'
        recipients = User.software.to_a
      when 'birthday'
        recipients = User.any_admin.to_a
      when 'order_status'
        recipients = User.where(id: self.user_id).to_a if self.user_id.present?
      when 'order_done'
        recipients = User.media.to_a
        recipients = recipients + User.where(id: self.user_id).to_a if self.user_id.present?
      when 'device_return'
        recipients = User.software.media.to_a
        recipients = recipients + User.technician.to_a if self.device.present? and self.device.location.is_repair?
      else
        recipients = []
    end
    self.recipient_ids = recipients.uniq.map { |r| r.id } if recipients.any?
  end

end
