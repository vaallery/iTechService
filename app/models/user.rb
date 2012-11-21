class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable, :rememberable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :token_authenticatable, :timeoutable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role, :username, :email, :password, :password_confirmation, :remember_me
  validates :username, presence: true
  
  scope :admins, where(role: 'admin')
  
  ROLES = %w[admin staff technician]
  
  def email_required?
    false
  end
  
  def timeout_in
    10.hours
  end
  
  def admin?
    has_role? 'admin'
  end
  
  def has_role? role
    self.role == role
  end
  
  def self.search search
    if search
      where "username LIKE ?", "%#{search}%"
    else
      scoped
    end
  end
  
  private
  
  def ensure_an_admin_remains
    errors[:base] << I18n::t('users.deny_destroing') and return false if User.admins.count == 1
  end
  
end
