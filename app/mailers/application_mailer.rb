class ApplicationMailer < ActionMailer::Base
  default from: "iTechService #{Department.current.name} <noreply@itechdevs.com>"
end