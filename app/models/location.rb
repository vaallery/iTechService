# encoding: utf-8
class Location < ActiveRecord::Base
  #default_scope order('position asc')
  scope :sorted, ->{order('position asc')}
  scope :for_schedule, ->{where(schedule: true)}
  belongs_to :department, inverse_of: :locations
  has_many :users
  has_many :tasks
  delegate :name, to: :department, prefix: true, allow_nil: true

  attr_accessible :name, :schedule, :position, :code, :department_id
  validates_presence_of :name

  def full_name
    path.all.map{|l|l.name}.join ' / '
  end

  def self.bar
    Location.where(code: 'bar').first_or_create(name: 'Бар')
  end

  def self.content
    Location.where(code: 'content').first_or_create(name: 'Обновление контента')
  end

  def self.done
    Location.where(code: 'done').first_or_create(name: 'Готово')
  end

  def self.archive
    Location.where(code: 'archive').first_or_create(name: 'Архив')
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

  def self.allowed_for(user, device)
    #if user.admin?
    #  scoped
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
      scoped
    else
      if user.present? && user.department.present?
        Location.where(department_id: user.department.id)
      else
        Location.where(department_id: Department.current.id)
      end
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

end
