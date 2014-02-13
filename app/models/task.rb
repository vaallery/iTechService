class Task < ActiveRecord::Base

  IMPORTANCE_BOUND = 5

  scope :important, where('priority > ?', IMPORTANCE_BOUND)
  scope :tasks_for, lambda { |user| where(task: {role: user.role}) }

  has_many :device_tasks, dependent: :destroy
  has_many :devices, through: :device_tasks
  belongs_to :product, inverse_of: :task
  belongs_to :location
  attr_accessible :cost, :duration, :name, :priority, :role, :location_id
  after_initialize { self.name ||= product.name if product.present? }

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

  def location_name
    location.try(:full_name) || '-'
  end

  def role_name
    role.blank? ? '-' : I18n.t("users.roles.#{role}")
  end

  def is_repair?
    # TODO define repair task
    true
  end

end
