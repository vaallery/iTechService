class ApplicationMailer < ActionMailer::Base
  default from: "iTechService <#{ENV['EMAIL_SENDER']}>"
end
