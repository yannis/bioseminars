# require 'development_mail_interceptor'

ActionMailer::Base.smtp_settings = {
  :address => "mail.unige.ch",
  :port => 25,
  :domain => "mail.unige.ch"
}

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?