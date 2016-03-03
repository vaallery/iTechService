class Feature < ActiveRecord::Base

  belongs_to :feature_type
  belongs_to :item, inverse_of: :features
  attr_accessible :value, :item_id, :feature_type_id
  validates_presence_of :value, :feature_type
  validates_uniqueness_of :value, scope: [:feature_type_id]
  validates_length_of :value, is: 15, if: :is_imei?
  delegate :name, :kind, :is_imei?, to: :feature_type, allow_nil: true

  default_scope ->{order('feature_type_id asc')}

  def as_json(options={})
    {
      id: id,
      kind: kind,
      name: name,
      value: value
    }
  end

end
