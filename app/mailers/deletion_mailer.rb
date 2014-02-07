class DeletionMailer < ActionMailer::Base
  include ApplicationHelper

  def notice(object, user, time)
    @object = object
    @user = user
    @time = time
    mail to: 'vitali.kolesnik@gmail.com', subject: t('mail.deletion.subject')
  end

end