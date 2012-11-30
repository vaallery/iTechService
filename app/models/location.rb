class Location < ActiveRecord::Base

  has_ancestry

  attr_accessible :name, :ancestry, :parent_id

  default_scope order('ancestry asc')

  scope :allowed_for, lambda { |user| where("ancestry LIKE ?", "#{user.location.ancestor_ids.join('/')}%") }

  def full_name
    path.all.map{|l|l.name}.join ' / '
  end

  def ancestors_names
    ancestors.all.map{|l|l.name}.join ' / '
  end

end
