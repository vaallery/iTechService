class User < ActiveRecord::Base

  ROLES = %w[admin software media technician marketing programmer supervisor]
  HELPABLE = %w[software media technician]
  ABILITIES = %w[manage_wiki]

  belongs_to :location
  has_many :history_records, as: :object
  has_many :schedule_days, dependent: :destroy
  has_many :duty_days, dependent: :destroy
  has_many :orders, as: :customer
  has_many :announcements
  has_many :comments
  has_many :devices, inverse_of: :user
  has_many :karmas, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :infos, inverse_of: :recipient, dependent: :destroy
  has_many :salaries, inverse_of: :user, dependent: :destroy

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
                  :card_number, :color, :karmas_attributes, :abilities, :schedule

  attr_accessor :login
  cattr_accessor :current

  accepts_nested_attributes_for :schedule_days, :duty_days, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :karmas, allow_destroy: true

  validates :username, :role, presence: true
  validates :password, presence: true, confirmation: true, if: :password_required?


  scope :admins, where(role: 'admin')
  scope :working_at, lambda { |day| joins(:schedule_days).where('schedule_days.day = ? AND LENGTH(schedule_days.hours) > 0', day) }
  scope :with_active_birthdays, joins(:announcements).where(announcements: {kind: 'birthday', active: true})
  scope :with_inactive_birthdays, joins(:announcements).where(announcements: {kind: 'birthday', active: false})
  scope :schedulable, where(schedule: true)
  scope :staff, where('role <> ?', 'admin')
  #scope :upcoming_salary, where('hiring_date IN ?', [Date.current..Date.current.advance(days: 2)])

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

  def supervisor?
    has_role? 'supervisor'
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

  def is_duty_today?
    duty_days.exists? day: Date.current
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
    User::HELPABLE.include? role
  end

  def color_s
    color.blank? ? '#ffffff' : color
  end

  def upcoming_birthday?
    if birthday.present?
      today = Date.current
      date = birthday.change(year: today.year)
      date = date.next_year if date < today
      date.between? today, 3.days.from_now.end_of_day.to_datetime
    else
      false
    end
  end

  def birthday_announcement
    announcements.find_or_create_by_kind(kind: 'birthday', active: false)
  end

  def timeout_in
    (Rails.env.production? and software?) ? 5.minutes : 1.day
  end

  def abilities=(abilities)
    self.abilities_mask = (abilities & ABILITIES).map { |a| 2**ABILITIES.index(a) }.inject(0, :+)
  end

  def abilities
    ABILITIES.reject { |a| ((abilities_mask || 0) & 2**ABILITIES.index(a)).zero? }
  end

  def able?(ability)
    abilities.include? ability.to_s
  end

  def location_name(full=false)
    location.blank? ? '' : (full ? location.full_name : location.name)
  end

  def rating
    good_count = karmas.good.count
    bad_count = karmas.bad.count
    (good_count > 0 or bad_count > 0) ? (good_count - bad_count) : 0
  end

  def upcoming_salary_date
    today = Date.current
    date = hiring_date.change month: today.month, year: today.year
    date < today ? date.next_month : date
  end

  def self.oncoming_salary
    today = Date.current
    User.all.keep_if do |user|
      if user.hiring_date.present?
        upcoming_salary_date = user.upcoming_salary_date
        upcoming_salary_date.between?(today, 2.days.from_now.end_of_day.to_datetime) and
            user.salaries.where(created_at: today..upcoming_salary_date, user_id: user.id).empty?
      end
    end.sort_by! do |user|
      user.upcoming_salary_date - today
    end
  end

  private
  
  def ensure_an_admin_remains
    errors[:base] << I18n::t('users.deny_destroing') and return false if User.admins.count == 1
  end

  def password_required?
    self.new_record?
  end
  
end
