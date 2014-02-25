class ProductRelation < ActiveRecord::Base

  belongs_to :parent, polymorphic: true
  belongs_to :relatable, polymorphic: true

end
