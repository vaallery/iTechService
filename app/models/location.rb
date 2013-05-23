# encoding: utf-8
class Location < ActiveRecord::Base

  has_ancestry
  has_many :users
  has_many :tasks
  attr_accessible :name, :ancestry, :parent_id, :schedule, :position
  default_scope order('position asc')
  scope :sorted, order('position asc')
  scope :for_schedule, where(schedule: true)

  def full_name
    path.all.map{|l|l.name}.join ' / '
  end

  def presentation
    full_name
  end

  def ancestors_names
    ancestors.all.map{|l|l.name}.join ' / '
  end

  def self.bar
    Location.find_by_name 'Бар'
  end

  def self.bar_id
    Location.find_by_name('Бар').try(:id)
  end

  def self.content
    Location.find_by_name 'Обновление контента'
  end

  def self.content_id
    Location.find_by_name('Обновление контента').try(:id)
  end

  def self.done
    Location.find_by_name 'Готово'
  end

  def self.done_id
    Location.find_by_name('Готово').try(:id)
  end

  def self.archive
    Location.find_by_name 'Архив'
  end

  def self.archive_id
    Location.find_by_name('Архив').try :id
  end

  def self.repair
    Location.find_by_name 'Ремонт'
  end

  def self.repair_id
    Location.find_by_name('Ремонт').try(:id)
  end

  def self.warranty
    Location.find_by_name 'Гарантийники'
  end

  def self.popov
    #Location.where(id: 10).try(:first)
    Location.where('LOWER(name) LIKE ?', "попов%").try(:first)
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
    scoped
  end

  def is_done?
    name == 'Готово'
  end

  def is_archive?
    name == 'Архив'
  end

  def is_repair?
    name == 'Ремонт'
  end

  def is_warranty?
    name == 'Гарантийники'
  end

  def is_popov?
    #id == 10
    name.mb_chars.downcase.to_s.start_with? 'попов'
  end

end
