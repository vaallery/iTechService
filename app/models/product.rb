class Product < ActiveRecord::Base
  belongs_to :group
  attr_accessible :code, :name, :group, :group_id
end
