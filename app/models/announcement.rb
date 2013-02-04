class Announcement < ActiveRecord::Base
  KINDS = %w[help coffee for_coffee protector info]

  belongs_to :user
  attr_accessible :content, :kind, :user_id, :active
  validates :kind, :user_id, presence: true
  default_scope order('created_at desc')
  scope :active, where(active: true)
  scope :active_help, where(active: true, kind: 'help')
  scope :active_coffee, where(active: true, kind: 'coffee')
  scope :active_protector, where(active: true, kind: 'protector')

  after_initialize do |announcement|
    announcement.kind ||= 'info'
    #announcement.active = false if announcement.active.nil?
  end

  def user_name
    user.full_name
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

  def visible_for
    case kind
      when 'help' then return 'software'
      when 'coffee' then return 'software'
      when 'for_coffee' then return 'media'
      when 'protector' then return 'software'
      else return ''
    end
  end

  def visible_for?(user)
    if user_id != user.id
      (user.software? and %w[help coffee protector].include?(kind)) or (user.media? and for_coffee?)
    else
      false
    end
  end

end
