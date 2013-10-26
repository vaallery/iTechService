class Feature < ActiveRecord::Base

  belongs_to :feature_type
  has_and_belongs_to_many :items
  attr_accessible :value, :feature_type_id
  validates_presence_of :value, :feature_type
  validates_uniqueness_of :value, scope: [:feature_type_id]
  validates_length_of :value, is: 15, if: :is_imei?
  delegate :name, :kind, :is_imei?, to: :feature_type

  default_scope includes(:feature_type).order('feature_types.name asc')

  def as_json(options={})
    {
      id: id,
      name: name,
      value: value
    }
  end

end
