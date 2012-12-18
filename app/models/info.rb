class Info < ActiveRecord::Base
  attr_accessible :content, :title

  validates :title, :content, presence: true

  default_scope order('created_at desc')
  scope :grouped_by_date

  private

  def grouped_by_date
    select("date(created_at) as info_date, count(title) as total_infos").group("infos.created_at::date)")
  end
end
