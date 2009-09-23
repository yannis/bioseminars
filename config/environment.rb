# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

if ENV['RAILS_ENV'] == 'production'
  # HOST = 'http://bioseminars.unige.ch'
  # SHORT_HOST = '129.194.56.197'
  # HOST = '129.194.56.197/seminars'
  SHORT_HOST = HOST = 'bioseminars.unige.ch'
else  
  SHORT_HOST = 'localhost:3000'
  HOST = 'localhost:3000'
end

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  
  config.gem "haml", :version => '>= 2.2.3'
  config.gem 'mislav-will_paginate', :version => '~> 2.3.8', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'icalendar'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :user_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Bern'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp # or  or test  :sendmail :smtp 
  config.action_mailer.smtp_settings = {
    :address => "mail.zoo.unige.ch",
    :port => 25,
    :domain => "mail.zoo.unige.ch"
  }
  

end

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
    :time_only => '%H:%M',
    :rfc2445 => '%Y%m%dT%H%M00',
    :rfc822 => '%a, %d %b %Y %H:%M:%S +0100',
    :day_month_year => "%e %B %Y",
    :dotted_day_month_year => "%e %B %Y",
    :day_month_year_hour_minute => "%e %B %Y, %H:%M"
  )
  ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!( 
      :month => '%B',
      :time_only => '%H:%M'
  )