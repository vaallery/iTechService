class User < ActiveRecord::Base

  belongs_to :location
  has_many :history_records, as: :object
  has_many :schedule_days, dependent: :destroy

  mount_uploader :photo, PhotoUploader
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable, :rememberable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :token_authenticatable, :timeoutable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role, :username, :email, :password, :password_confirmation, :remember_me, :location_id,
                  :surname, :name, :patronymic, :birthday, :hiring_date, :salary_date, :prepayment,
                  :photo, :remove_photo, :photo_cache, :schedule_days_attributes

  accepts_nested_attributes_for :schedule_days

  validates :username, :role, presence: true
  validates :password, presence: true, confirmation: true, if: :password_required?

  cattr_accessor :current
  
  scope :admins, where(role: 'admin')

  after_initialize do |user|
    if user.schedule_days.empty?
      (1..7).each do |d|
        user.schedule_days.build day: d
      end
    end
  end
  
  def email_required?
    false
  end
  
  def timeout_in
    10.hours
  end
  
  def admin?
    has_role? 'admin'
  end

  def not_admin?
    !admin?
  end

  def technician?
    has_role? 'technician'
  end

  def software?
    has_role? 'software'
  end

  def media?
    has_role? 'media'
  end
  
  def has_role? role
    if role.is_a? Array
      role.include? self.role
    else
      self.role == role
    end
  end
  
  def self.search search
    if search
      where "username LIKE ?", "%#{search}%"
    else
      scoped
    end
  end

  def full_name
    [surname, name, patronymic].join ' '
  end

  private
  
  def ensure_an_admin_remains
    errors[:base] << I18n::t('users.deny_destroing') and return false if User.admins.count == 1
  end

  def password_required?
    self.new_record?
  end
  
end
