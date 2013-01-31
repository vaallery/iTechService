class StolenPhone < ActiveRecord::Base

  has_many :comments, as: :commentable, dependent: :destroy
  attr_accessible :imei, :comment, :comments_attributes
  attr_accessor :comment
  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }
  validates :imei, presence: true, length: {is: 15}
  validates_associated :comments

  def self.search params
    stolen_phones = StolenPhone.scoped
    unless (imei_q = params[:imei_q]).blank?
      stolen_phones = stolen_phones.where "LOWER(stolen_phones.imei) LIKE :q", q: "%#{imei_q}%"
    end
    stolen_phones
  end

  def comment=(content)
    comments.build content: content unless content.blank?
  end

end
