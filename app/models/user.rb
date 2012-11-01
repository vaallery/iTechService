class User < ActiveRecord::Base
  attr_accessible :role, :username
end
