class Department < ActiveRecord::Base

  ROLES = {
    0 => 'main',
    1 => 'branch',
    2 => 'store'
  }

  default_scope order('departments.id asc')

  has_many :users, dependent: :nullify
  has_many :stores, dependent: :nullify

  attr_accessible :name, :role, :code, :url, :city, :address, :contact_phone, :schedule
  validates_presence_of :name, :role
  validates_presence_of :city, :address, :contact_phone, :schedule, :url, unless: :is_store?
  validate :only_one_main

  def role_s
    ROLES[role]
  end

  def is_store?
    role == 2
  end

  private

  def only_one_main
    errors.add :role, :main_exists if role == 0 and Department.exists?(role: 0)
    false
  end

end
