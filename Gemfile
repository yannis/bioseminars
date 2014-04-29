source 'https://rubygems.org'

gem 'rails', '4.1.0.rc2'
gem 'mysql2'
gem 'bundler'
gem "kaminari"
gem 'paperclip'
gem "bio", '~>1.4.3'
gem 'htmlentities'
gem "actionview-encoded_mail_to"
gem "active_model_serializers"
gem "icalendar", "2.0.1"
gem "devise"
gem "devise-encryptable"
gem 'uglifier', '>= 1.3.0'

gem 'sass-rails', '~> 4.0'
gem 'coffee-rails'
gem 'haml-rails'
gem 'html5-rails'
gem 'jquery-rails'
gem "jquery-ui-rails"
gem 'ember-rails'
gem "ember-source", "1.5.0"
gem "ember-data-source", "1.0.0.beta.7"
gem "calendar_date_select"
gem 'bootstrap3-datetimepicker-rails', '~> 3.0.0'
gem "font-awesome-sass"
gem "bootstrap-sass"
gem "calendar_helper"
gem 'momentjs-rails', '~> 2.5.0'
gem 'compass-rails'

gem 'airbrake'
gem "newrelic_rpm"

group :development do
  gem "spring"
  gem 'spring-commands-rspec'
  gem "capistrano"
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.0'
  gem "guard-livereload"
  gem 'guard-spring'
  gem 'guard-rspec', require: false
  gem 'guard-bundler'
  gem 'rb-inotify', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-fchange', require: false
  gem 'quiet_assets'
  gem "better_errors"
  gem "binding_of_caller"
  gem "rspec-rails"
  gem "rails_best_practices"
  gem "brakeman", :require => false
  gem "debugger"
  gem "bullet"
end

group :test do
  gem "rspec-instafail"
  gem "launchy"
  gem "database_cleaner"
  gem "faker"
  gem 'timecop'
  gem 'email_spec'
  gem "factory_girl_rails"
  gem "selenium-webdriver"
  gem "capybara-webkit"
  gem "minitest" # temporary fix for https://github.com/thoughtbot/shoulda-matchers/issues/408
  gem 'shoulda-matchers'
  gem 'capybara-screenshot', git: "git://github.com/mattheworiordan/capybara-screenshot.git"
  gem 'simplecov', :require => false
end

group :production do
  gem 'god'
  gem "unicorn"
end
