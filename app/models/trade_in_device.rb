class TradeInDevice < ActiveRecord::Base
  scope :ordered, -> { order :number }
  scope :archived, -> { where archived: true }
  scope :not_archived, -> { where archived: false }

  belongs_to :item
  belongs_to :receiver, class_name: 'User'
  has_many :features, through: :item
  has_many :comments, as: :commentable

  validates_presence_of :number, :received_at, :item, :appraised_value, :appraiser, :bought_device,
                        :client_name, :client_phone, :check_icloud

  delegate :name, :presentation, to: :item

  enum replacement_status: {not_replaced: 0, replaced: 1, in_service: 2}

  def self.search(query, in_archive: false, sort_column: nil, sort_direction: :asc)
    result = in_archive ? archived : not_archived
    unless query.blank?
      result = result.includes(:features, :receiver, item: :products)
                 .where('LOWER(features.value) LIKE :q', q: "%#{query.mb_chars.downcase.to_s}%").references(:features)
    end

    if sort_column
      result.order(sort_column => sort_direction)
    else
      result.ordered
    end
  end
end
