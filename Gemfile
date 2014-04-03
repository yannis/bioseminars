source 'https://rubygems.org'

gem 'rails', '4.1.0.rc2'
gem 'mysql2'
gem 'haml-rails'
gem 'html5-rails'
gem "devise"
gem "devise-encryptable"
gem "hpricot"
gem "ruby_parser"
gem 'paperclip'
gem "bio", '~>1.4.3'
gem "calendar_date_select"
gem 'htmlentities'
gem "kaminari"
gem "calendar_helper"
gem 'airbrake'
gem "newrelic_rpm"
gem 'bundler'
gem "actionview-encoded_mail_to"
gem 'bootstrap-sass', "~> 3.1"
gem "active_model_serializers"
gem 'momentjs-rails', '~> 2.5.0'
gem 'bootstrap3-datetimepicker-rails', '~> 3.0.0'

gem 'jquery-rails'
gem 'ember-rails'#, git: 'git://github.com/emberjs/ember-rails.git' # ember-rails (0.14.0 88d56f2)
gem "ember-source", "1.5.0"
gem "ember-data-source", "1.0.0.beta.7"
gem "jquery-ui-rails"
gem 'coffee-rails'
gem "icalendar", git: "git://github.com/icalendar/icalendar"

group :assets do
  gem 'sass-rails', '~> 4.0'#, git: 'git://github.com/emberjs/ember-rails.git'
  gem 'uglifier', '>= 1.3.0'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem "spring"
  gem 'spring-commands-rspec'
  gem "capistrano"
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.0'
  gem "guard-livereload"
  gem 'guard-spring'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'rb-fsevent', require: false
  gem 'quiet_assets'
  gem "better_errors"
  gem "binding_of_caller"
  gem "rspec-rails"
  gem "rails_best_practices"
  # gem "brakeman", :require => false
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
  gem 'capybara-screenshot', git: "git://github.com/mattheworiordan/capybara-screenshot.git"# , :require => false
  gem 'simplecov', :require => false
end

group :production do
  gem 'god'
  gem "unicorn"
end
