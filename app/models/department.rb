class Department < ActiveRecord::Base

  ROLES = {
    0 => 'main',
    1 => 'branch',
    2 => 'store',
    3 => 'remote',
  }

  default_scope {order('departments.id asc')}
  scope :branches, ->{where(role: 1)}
  scope :selectable, -> { where(role: [0, 3]) }

  has_many :users, dependent: :nullify
  has_many :stores, dependent: :nullify
  has_many :cash_drawers, dependent: :nullify
  has_many :settings, dependent: :destroy
  has_many :service_jobs, inverse_of: :department
  has_many :locations, inverse_of: :department
  # cattr_accessor :current

  attr_accessible :name, :role, :code, :url, :city, :address, :contact_phone, :schedule, :printer, :ip_network
  validates_presence_of :name, :role, :code
  validates_presence_of :city, :address, :contact_phone, :schedule, unless: :is_store?
  validates :url, presence: true, if: :has_server?
  validate :only_one_main

  def role_s
    ROLES[role]
  end

  def is_main?
    role == 0
  end

  def is_branch?
    role == 1
  end

  def is_store?
    role == 2
  end

  def is_remote?
    role == 3
  end

  def has_server?
    role.in? 0..1
  end

  def self.current
    Department.find_by_code(ENV['DEPARTMENT_CODE'] || 'vl') || Department.first
  end

  def spare_parts_store
    stores.spare_parts.first
  end

  def defect_sp_store
    stores.defect_sp.first
  end

  def repair_store
    stores.repair.first_or_create(name: I18n.t('stores.kinds.repair'))
  end

  def default_cash_drawer
    cash_drawers.first_or_create name: 'Cash drawer 1'
  end

  def current_cash_shift
    default_cash_drawer.current_shift
  end

  private

  def only_one_main
    errors.add :role, :main_exists if role == 0 and Department.where('id <> ? AND role = ?', self.id, 0).count > 1
    false
  end

end
