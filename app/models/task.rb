class Task < ActiveRecord::Base
  belongs_to :user
  has_many :device_tasks, dependent: :destroy
  has_many :devices, through: :device_tasks
  attr_accessible :cost, :duration, :name, :priority
  validates :name, presence: true
  
  IMPORTANCE_BOUND = 5
  
  scope :important, where('priority > ?', IMPORTANCE_BOUND)
  
  
  def is_important?
    priority > IMPORTANCE_BOUND
  end
  
end