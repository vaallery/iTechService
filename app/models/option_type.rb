class OptionType < ActiveRecord::Base
  default_scope { order :position }
  has_many :option_values
  accepts_nested_attributes_for :option_values, allow_destroy: true, reject_if: proc { |a| a[:name].blank? }
  validates :name, presence: true, uniqueness: true
  validates :code, uniqueness: {allow_blank: true}
  acts_as_list
end
