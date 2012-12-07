class Karma < ActiveRecord::Base
  belongs_to :user
  attr_accessible :comment, :good
end
