class User < ActiveRecord::Base

  belongs_to :location
  has_many :history_records, as: :object
  has_many :schedule_days, dependent: :destroy
  has_many :duty_days, dependent: :destroy
  has_many :orders, as: :customer
  has_many :announcements
  has_many :comments
  has_many :devices, inverse_of: :user

  mount_uploader :photo, PhotoUploader
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable, :rememberable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :token_authenticatable, :timeoutable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role, :login, :username, :email, :password, :password_confirmation, :remember_me, :location_id,
                  :surname, :name, :patronymic, :birthday, :hiring_date, :salary_date, :prepayment, :wish,
                  :photo, :remove_photo, :photo_cache, :schedule_days_attributes, :duty_days_attributes,
                  :card_number, :color

  attr_accessor :login

  accepts_nested_attributes_for :schedule_days, :duty_days, allow_destroy: true, reject_if: :all_blank
  #accepts_nested_attributes_for :duty_days, allow_destroy: true

  validates :username, :role, presence: true
  validates :password, presence: true, confirmation: true, if: :password_required?

  cattr_accessor :current

  #default_scope order('id asc')
  scope :admins, where(role: 'admin')
  scope :working_at, lambda { |day| joins(:schedule_days).where('schedule_days.day = ? AND LENGTH(schedule_days.hours) > 0', day) }
  scope :with_active_birthdays, joins(:announcements).where(announcements: {kind: 'birthday', active: true})
  scope :with_inactive_birthdays, joins(:announcements).where(announcements: {kind: 'birthday', active: false})

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

  def marketing?
    has_role? 'marketing'
  end

  def programmer?
    has_role? 'programmer'
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
    res = [surname, name, patronymic].join ' '
    res = username if res.blank?
    res
  end

  def short_name
    res = [name, surname].join ' '
    res = username if res.blank?
    res
  end

  def presentation
    short_name
  end

  def is_duty_day? date
    duty_days.exists? day: date
  end

  def is_work_day? day
    day = day.respond_to?(:wday) ? day.wday : day.to_i
    if (schedule_day = schedule_days.find_by_day(day)).present?
      schedule_day.hours.present?
    else
      false
    end
  end

  def is_shortened_day? date
    if is_work_day? date
      hours = schedule_days.find_by_day(date.wday).hours.split(',').map{|h|h.to_i}.sort
      hours[-1] < 20
    else
      false
    end
  end

  def announced?
    case role
      when 'software' then announcements.active_help.any?
      when 'media' then announcements.active_coffee.any?
      when 'technician' then announcements.active_protector.any?
      else false
    end
  end

  def announced_birthday?
    announcements.active_birthdays.any?
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(card_number) = :value",
                               { value: login.mb_chars.downcase.to_s }]).first
    else
      where(conditions).first
    end
  end

  def helpable?
    Role::HELPABLE.include? role
  end

  def color_s
    color.blank? ? '#ffffff' : color
  end

  def upcoming_birthday?
    today = Date.current
    birthday.present? and (0..3).include? (birthday.change(year: today.year) - today).to_i
  end

  def birthday_announcement
    announcements.find_or_create_by_kind(kind: 'birthday', active: false)
  end

  private
  
  def ensure_an_admin_remains
    errors[:base] << I18n::t('users.deny_destroing') and return false if User.admins.count == 1
  end

  def password_required?
    self.new_record?
  end
  
end
