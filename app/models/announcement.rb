class Announcement < ActiveRecord::Base
  KINDS = %w[help info]

  belongs_to :user
  attr_accessible :content, :type, :user_id, :active
  validates :kind, :user_id, :active, presence: true
  default_scope order('created_at desc')
  scope :active, where(active: true)
  scope :active_help, where(active: true, kind: KINDS[0])

  after_initialize do |announcement|
    announcement.kind ||= KINDS[0]
    announcement.active ||= true
  end

  def user_name
    user.full_name
  end

  def help?
    kind == KINDS[0]
  end

end
