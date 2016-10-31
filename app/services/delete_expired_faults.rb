class DeleteExpiredFaults
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    if user.present?
      delete_faults_of user
    else
      User.all.each do |user|
        delete_faults_of user
      end
    end
  end

  def self.call(user=nil)
    new(user).call
  end

  private

  def delete_faults_of(user)
    if (expiration_date = past_salary_date_of user).present?
      user.faults.expireable.where('date < ?', expiration_date).delete_all
    end
  end

  def past_salary_date_of(user)
    if (hiring_date = user.hiring_date).present?
      date = current_month_salary_date hiring_date
      date.past? ? date : date.prev_month
    end
  end

  def current_month_salary_date(hiring_date)
    today = Date.current
    if today.end_of_month.day < hiring_date.day
      hiring_date.change(day: today.end_of_month.day, month: today.month, year: today.year)
    else
      hiring_date.change(month: today.month, year: today.year)
    end
  end
end