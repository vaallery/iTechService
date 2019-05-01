class ApplicationMailer < ActionMailer::Base
  default from: "iTechService #{Department.current.name} <#{ENV['SMTP_LOGIN']}>"
end
