class Info < ActiveRecord::Base

  attr_accessible :content, :title, :important

  validates :title, :content, presence: true

  scope :newest, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :grouped_by_date
  scope :important, where(important: true)

  private

  def grouped_by_date
    select("date(created_at) as info_date, count(title) as total_infos").group("infos.created_at::date)")
  end

end
