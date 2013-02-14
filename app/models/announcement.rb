class Announcement < ActiveRecord::Base
  KINDS = %w[help coffee for_coffee protector info birthday]

  belongs_to :user
  attr_accessible :content, :kind, :user_id, :active
  validates :kind, :user_id, presence: true
  scope :ordered, order('created_at desc')
  scope :active, where(active: true)
  scope :active_help, where(active: true, kind: 'help')
  scope :active_coffee, where(active: true, kind: 'coffee')
  scope :active_protector, where(active: true, kind: 'protector')
  scope :active_birthdays, where(active: true, kind: 'birthday')

  after_initialize do |announcement|
    announcement.kind ||= 'info'
    #announcement.active = false if announcement.active.nil?
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

  def visible_for
    case kind
      when 'help' then return 'software'
      when 'coffee' then return 'software'
      when 'for_coffee' then return 'media'
      when 'protector' then return 'software'
      when 'birthday' then return 'admin'
      else return ''
    end
  end

  def visible_for?(user)
    if user_id != user.id
      (user.software? and %w[help coffee protector].include?(kind)) or (for_coffee? and user.media?) or
          (user.admin? and birthday?)
    else
      false
    end
  end

end
