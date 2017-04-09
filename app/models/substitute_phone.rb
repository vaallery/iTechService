class SubstitutePhone < ApplicationRecord
  include Authorizable
  belongs_to :item
  has_many :features, through: :item

  def self.search(query)
    if query.blank?
      self.all
    else
      self.includes(:features).where('LOWER(features.value) LIKE :q', q: "%#{query.mb_chars.downcase.to_s}%").references(:features)
    end
  end
end
