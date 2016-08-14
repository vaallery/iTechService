class Feature < ActiveRecord::Base

  scope :imei, -> { includes(:feature_type).where(feature_types: {kind: 'imei'}) }
  scope :serial_number, -> { includes(:feature_type).where(feature_types: {kind: 'serial_number'}) }

  belongs_to :feature_type
  belongs_to :item, inverse_of: :features
  attr_accessible :value, :item, :item_id, :feature_type, :feature_type_id
  validates_presence_of :value, :feature_type
  validates_uniqueness_of :value, scope: [:feature_type_id], unless: Proc.new { |feature| feature.value == '?' }
  validates_length_of :value, is: 15, if: Proc.new { |feature| feature.is_imei? && feature.value != '?' }
  delegate :name, :kind, :is_imei?, to: :feature_type, allow_nil: true

  default_scope {order('feature_type_id asc')}

  def as_json(options={})
    {
      id: id,
      kind: kind,
      name: name,
      value: value
    }
  end

end
