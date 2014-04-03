ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => Rails.application.secrets.outlook_server,
  :port => Rails.application.secrets.outlook_port,
  :enable_starttls_auto => true,
  :user_name => Rails.application.secrets.outlook_user,
  :password => Rails.application.secrets.outlook_password,
  :authentication => :login
}
