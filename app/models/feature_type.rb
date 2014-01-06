class FeatureType < ActiveRecord::Base

  KINDS = %w[imei serial_number other]

  has_and_belongs_to_many :product_categories
  attr_accessible :name, :kind, :product_category_ids
  validates_presence_of :name, :kind
  validates_uniqueness_of :kind, unless: :is_other?
  validates_inclusion_of :kind, in: KINDS

  def is_imei?
    kind == 'imei'
  end

  def is_other?
    kind == 'other'
  end

end
