class Salary < ActiveRecord::Base

  belongs_to :user, inverse_of: :salaries
  has_many :comments, as: :commentable, dependent: :destroy
  attr_accessible :amount, :user, :user_id#, :comments_attributes
  validates_presence_of :user, :amount
  #accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: proc { |attr| attr['content'].blank? }
  #validates_associated :comments

  scope :ordered, order('created_at desc')

  def comment=(content)
    comments.build content: content unless content.blank?
  end

  def self.search(params)
    salaries = Salary.ordered.includes :user
    unless (user_q = params[:user_q]).blank?
      salaries = salaries.where 'LOWER(users.name) LIKE :q OR LOWER(users.surname) LIKE :q',
                                q: "%#{user_q.mb_chars.downcase.to_s}%"
    end
    salaries
  end

end
