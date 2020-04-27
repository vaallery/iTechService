# encoding: utf-8
class Location < ActiveRecord::Base
  scope :ordered, -> { order('position asc') }
  scope :in_department, ->(department) { where department: department }
  scope :for_schedule, -> { where(schedule: true) }
  scope :visible, -> { where hidden: [false, nil] }
  scope :done, -> { where code: 'done' }
  scope :code_start_with, ->(code) { where('code LIKE ?', "#{code}%") }

  scope :search, ->(params) do
    where(department_id: params[:department_id]) if params.key?(:department_id)
  end

  belongs_to :department, required: true, inverse_of: :locations
  has_many :users
  has_many :tasks
  delegate :name, to: :department, prefix: true, allow_nil: true
  delegate :city, to: :department, allow_nil: true

  attr_accessible :name, :schedule, :position, :code, :department_id, :hidden, :storage_term
  validates_presence_of :name

  def full_name
    path.all.map { |l| l.name }.join(' / ')
  end

  def self.bar
    Location.where(code: 'bar').first_or_create(name: 'Бар')
  end

  def self.content
    Location.where(code: 'content').first_or_create(name: 'Обновление контента')
  end

  # def self.done
  #   Location.where(code: 'done').first_or_create(name: 'Готово')
  # end

  def self.archive
    Location.where(code: 'archive').first_or_create(name: 'Архив')
  end

  def self.archive_ids
    where(code: 'archive').pluck(:id)
  end

  def self.repair
    Location.where(code: 'repair').first_or_create(name: 'Ремонт')
  end

  def self.warranty
    Location.where(code: 'warranty').first_or_create(name: 'Гарантийники')
  end

  def self.popov
    Location.where(code: 'repair_notebooks').first_or_create(name: 'Ремонт ноутбуков')
  end

  def self.allowed_for(user, service_job)
    #if user.admin?
    #  all
    #elsif user.location.nil?
    #  []
    #else
      #locations = Location.where("ancestry LIKE ? OR ancestry is NULL", "#{user.location.ancestor_ids.join('/')}%")
      #locations = Location.where("ancestry LIKE ?", "#{user.location.ancestor_ids.join('/')}%")
      #locations = locations.joins(:users).uniq
      #locations_ids = []
      #locations_ids << Location.popov.id if Location.popov.present?
      #unless device.new_record?
      #  locations_ids << Location.archive.id if device.location.is_done? and Location.archive.present?
      #  locations_ids << Location.done.id if device.pending_tasks.empty? and Location.done.present?
      #  locations_ids << Location.warranty.id if device.location.is_repair? and Location.warranty.present?
      #end
      #locations = locations.where locations: {id: locations_ids}
      #locations
    #end
    if user.admin?
      visible
    else
      # department = (user.present? && user.department.present?) ? user.department : Department.current
      department = (service_job.present? && service_job.department.present?) ? service_job.department : Department.current
      visible.where(department_id: department.id)
    end
  end

  def is_done?
    code == 'done'
  end

  def is_archive?
    code == 'archive'
  end

  def is_repair?
    code == 'repair'
  end

  def is_warranty?
    code == 'warranty'
  end

  def is_repair_notebooks?
    code == 'repair_notebooks'
  end

  def is_any_repair?
    code.to_s.start_with?('repair')
  end

  def is_special?
    code == 'special'
  end
end
