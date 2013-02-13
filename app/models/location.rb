# encoding: utf-8
class Location < ActiveRecord::Base

  has_many :users
  has_ancestry
  attr_accessible :name, :ancestry, :parent_id, :schedule
  default_scope order('ancestry asc')
  #scope :allowed_for, lambda { |user| where("ancestry LIKE ? OR ancestry is NULL",
  #                                          "#{user.location.ancestor_ids.join('/')}%") }
  scope :for_schedule, where(schedule: true)

  def full_name
    path.all.map{|l|l.name}.join ' / '
  end

  def ancestors_names
    ancestors.all.map{|l|l.name}.join ' / '
  end

  def self.done
    Location.find_by_name 'Готово'
  end

  def self.archive
    Location.find_by_name 'Архив'
  end

  def self.repair
    Location.find_by_name 'Ремонт'
  end

  def self.warranty
    Location.find_by_name 'Гарантийники'
  end

  def self.allowed_for(user, device)
    if user.admin?
      all
    elsif user.location.nil?
      []
    else
      #locations = Location.where("ancestry LIKE ? OR ancestry is NULL", "#{user.location.ancestor_ids.join('/')}%")
      locations = Location.where("ancestry LIKE ?", "#{user.location.ancestor_ids.join('/')}%")
      locations = locations.joins(:users).uniq
      unless device.new_record?
        locations << Location.archive if device.location.is_done?
        locations << Location.done if device.pending_tasks.empty?
        locations << Location.warranty if device.location.is_repair?
      end
      locations
    end
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

end
