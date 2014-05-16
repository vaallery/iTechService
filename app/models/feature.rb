class Feature < ActiveRecord::Base

  default_scope order('feature_type_id asc')
  belongs_to :feature_type, primary_key: :uid
  belongs_to :item, inverse_of: :features, primary_key: :uid
  delegate :name, :kind, :is_imei?, to: :feature_type, allow_nil: true
  attr_accessible :value, :item_id, :feature_type_id
  validates_presence_of :value, :feature_type
  validates_uniqueness_of :value, scope: [:feature_type_id]
  validates_length_of :value, is: 15, if: :is_imei?
  after_create UidCallbacks

  def self.find(*args, &block)
    begin
      super
    rescue ActiveRecord::RecordNotFound
      self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
    end
  end

  def as_json(options={})
    {
      id: id,
      uid: uid,
      kind: kind,
      name: name,
      value: value
    }
  end

end
