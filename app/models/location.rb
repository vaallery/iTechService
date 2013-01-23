class Location < ActiveRecord::Base

  has_many :users
  has_ancestry
  attr_accessible :name, :ancestry, :parent_id, :schedule
  default_scope order('ancestry asc')
  scope :allowed_for, lambda { |user| where("ancestry LIKE ? OR ancestry is NULL",
                                            "#{user.location.ancestor_ids.join('/')}%") }
  scope :for_schedule, where(schedule: true)

  def full_name
    path.all.map{|l|l.name}.join ' / '
  end

  def ancestors_names
    ancestors.all.map{|l|l.name}.join ' / '
  end

end
