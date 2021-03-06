class Task < ApplicationRecord
  IMPORTANCE_BOUND = 5

  scope :important, -> { where('priority > ?', IMPORTANCE_BOUND) }
  scope :tasks_for, ->(user) { where(task: {role: user.role}) }
  scope :visible, -> { where hidden: [false, nil] }

  belongs_to :product, inverse_of: :task
  has_many :device_tasks, dependent: :restrict_with_error
  has_many :service_jobs, through: :device_tasks
  delegate :item, :is_repair?, :is_service?, to: :product, allow_nil: true
  delegate :name, :id, to: :location, prefix: true, allow_nil: true

  attr_accessible :cost, :duration, :name, :code, :priority, :role, :location_code, :product_id, :hidden

  after_initialize do
    if persisted? and product.nil?
      update_attribute :product_id, Product.services.where(code: "task#{id}").first_or_create(name: name, product_group_id: ProductGroup.services.first_or_create(name: 'Services', product_category_id: ProductCategory.where(kind: 'service').first_or_create(name: 'Service', kind: 'service').id).id).id
    end
  end

  def location(department = nil)
    department ||= Department.current
    Location.find_by(code: location_code, department: department)
  end

  def is_important?
    priority > IMPORTANCE_BOUND
  end

  def has_role?(role)
    if role.is_a? Array
      role.include? self.role
    else
      self.role == role
    end
  end

  def role_name
    role.blank? ? '-' : I18n.t("users.roles.#{role}")
  end
end
