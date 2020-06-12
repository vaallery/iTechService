class ApplicationMailer < ActionMailer::Base
  default from: "iTechService #{Department.current.name} <#{ENV['EMAIL_SENDER']}>"
end
