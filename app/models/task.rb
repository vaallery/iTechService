class Task < ActiveRecord::Base

  IMPORTANCE_BOUND = 5

  scope :important, where('priority > ?', IMPORTANCE_BOUND)
  scope :tasks_for, lambda { |user| where(task: {role: user.role}) }

  belongs_to :product, inverse_of: :task, primary_key: :uid
  belongs_to :location, primary_key: :uid
  has_many :device_tasks, dependent: :destroy, primary_key: :uid
  has_many :devices, through: :device_tasks, primary_key: :uid

  delegate :item, to: :product, allow_nil: true
  delegate :name, to: :location, prefix: true, allow_nil: true

  attr_accessible :cost, :duration, :name, :priority, :role, :location_id

  after_create UidCallbacks

  after_initialize do
    if persisted? and product.nil?
      update_attribute :product_id, create_product(name: name, code: "task#{id}", product_group_id: ProductGroup.services.first_or_create(name: 'Services', product_category_id: ProductCategory.where(kind: 'service').first_or_create(name: 'Service', kind: 'service').id).id).id
    end
  end

  def is_important?
    priority > IMPORTANCE_BOUND
  end

  def has_role? role
    if role.is_a? Array
      role.include? self.role
    else
      self.role == role
    end
  end

  def is_actual_for? user
    role == user.role
  end

  def responcible_users
    User.where role: role
  end

  def role_name
    role.blank? ? '-' : I18n.t("users.roles.#{role}")
  end

  def is_repair?
    has_role? 'technician'
  end

end
