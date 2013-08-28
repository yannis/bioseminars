# # require 'development_mail_interceptor'

# ActionMailer::Base.smtp_settings = {
#   :address => "mail.unige.ch",
#   :port => 25,
#   :domain => "mail.unige.ch"
# }

# ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "outlook.unige.ch",
  :port => 587,
  :enable_starttls_auto => true,
  :user_name => 'genev',
  :password => 'bwxdc7',
  :authentication => :login
}
