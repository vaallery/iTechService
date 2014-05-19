class FeatureType < ActiveRecord::Base

  KINDS = %w[imei serial_number other]

  default_scope order('feature_types.kind asc')
  scope :ordered, order('feature_types.kind asc')

  has_and_belongs_to_many :product_categories
  attr_accessible :name, :kind, :product_category_ids
  validates_presence_of :name, :kind
  validates_uniqueness_of :kind, unless: :is_other?
  validates_inclusion_of :kind, in: KINDS

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

  def is_imei?
    kind == 'imei'
  end

  def is_other?
    kind == 'other'
  end

  def self.imei
    FeatureType.find_or_create_by_kind kind: 'imei', name: 'IMEI'
  end

  def self.serial_number
    FeatureType.find_or_create_by_kind kind: 'serial_number', name: 'Serial Number'
  end

end
