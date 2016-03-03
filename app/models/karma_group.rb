class KarmaGroup < ActiveRecord::Base
  belongs_to :bonus, inverse_of: :karma_group
  has_many :karmas, dependent: :nullify, inverse_of: :karma_group
  accepts_nested_attributes_for :bonus, reject_if: proc { |attr| attr['bonus_type_id'].blank? }
  attr_accessible :bonus_id, :bonus_attributes, :karma_ids

  scope :used, ->{where('bonus_id != ?', nil)}
  scope :unused, ->{where(bonus_id: nil)}

  def is_used?
    bonus_id.present?
  end

  def size
    karmas.count
  end

  def user
    karmas.any? ? karmas.first.user : nil
  end

end
