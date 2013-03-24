class Info < ActiveRecord::Base

  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessor :comment
  attr_accessible :content, :title, :important, :comment, :comments_attributes
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }

  validates :title, :content, presence: true
  validates_associated :comments

  scope :newest, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :grouped_by_date
  scope :important, where(important: true)

  def comment=(content)
    comments.build content: content unless content.blank?
  end

  private

  def grouped_by_date
    select("date(created_at) as info_date, count(title) as total_infos").group("infos.created_at::date)")
  end

end
