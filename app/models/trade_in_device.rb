class TradeInDevice < ActiveRecord::Base
  scope :ordered, -> { order :number }
  scope :archived, -> { where archived: true }
  scope :not_archived, -> { where archived: false }

  belongs_to :item
  belongs_to :receiver, class_name: 'User'
  has_many :features, through: :item
  enum replacement_status: {not_replaced: 0, replaced: 1, in_service: 2}

  delegate :name, to: :item

  validates_presence_of :number, :received_at, :item, :receiver, :appraised_value, :appraiser, :bought_device,
                        :client_name, :client_phone, :check_icloud

  def self.search(query, in_archive: false)
    result = in_archive ? archived : not_archived
    return result if query.blank?
    result = result.includes(:features).where('LOWER(features.value) LIKE :q', q: "%#{query.mb_chars.downcase.to_s}%").references(:features)
    result.ordered
  end
end
