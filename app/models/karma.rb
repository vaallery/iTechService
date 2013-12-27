class Karma < ActiveRecord::Base

  GROUP_SIZE = 50

  belongs_to :user, inverse_of: :karmas
  belongs_to :karma_group, inverse_of: :karmas
  attr_accessible :comment, :user_id, :karma_group_id, :good
  validates_presence_of :user, :comment
  default_scope order('created_at asc')
  scope :created_asc, order('created_at asc')
  scope :good, where(good: true)
  scope :bad, where(good: false)
  scope :used, includes(:karma_group).where('karma_groups.bonus_id != ?', nil)
  scope :unused, includes(:karma_group).where(karma_groups: {bonus_id: nil})
  scope :ungrouped, where(karma_group_id: nil)
  scope :created_at, lambda {|date| where(created_at: date.beginning_of_day..date.end_of_day)}

  def kind
    good ? 'good' : 'bad'
  end

  def is_grouped?
    karma_group.present?
  end

  def is_ungrouped?
    karma_group.nil?
  end

  def user_presentation
    user.present? ? user.presentation : ''
  end

  def group_with(karma2)
    if self.is_ungrouped? and self.good? and karma2.is_ungrouped? and karma2.good?
      new_karma_group = KarmaGroup.create
      self.update_attributes karma_group_id: new_karma_group.id
      karma2.update_attributes karma_group_id: new_karma_group.id
      true
    else
      false
    end
  end

  def add_to_group(new_karma_group)
    if self.good?
      old_karma_group = self.karma_group.present? ? KarmaGroup.find(self.karma_group_id) : nil
      self.update_attributes karma_group_id: new_karma_group.id
      old_karma_group.destroy if old_karma_group.present? and old_karma_group.karmas.empty?
      true
    else
      false
    end
  end

  def ungroup
    old_karma_group = KarmaGroup.find self.karma_group_id
    if self.update_attributes karma_group_id: nil
      old_karma_group.destroy if old_karma_group.present? and old_karma_group.karmas.empty?
      true
    else
      false
    end
  end

end
