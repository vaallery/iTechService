class Task < ActiveRecord::Base
  has_many :device_tasks, dependent: :destroy
  has_many :devices, through: :device_tasks
  attr_accessible :cost, :duration, :name, :priority, :role
  validates :name, presence: true
  
  IMPORTANCE_BOUND = 5
  
  scope :important, where('priority > ?', IMPORTANCE_BOUND)
  scope :tasks_for, lambda { |user| where(task: {role: user.role}) }

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

end
