require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Bioseminars
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = "Europe/Zurich"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = false

    config.action_mailer.default_url_options = { host: Rails.application.secrets.mailer_host }

    config.assets.paths << "#{Rails.root}/vendor/assets/ember"
    config.assets.paths << "#{Rails.root}/vendor/bootstrap-datetimepicker"
    config.assets.paths << "#{Rails.root}/vendor/jquery-miniColors"
    config.assets.paths << "#{Rails.root}/vendor/momentjs"
    config.assets.paths << "#{Rails.root}/vendor/bootbox"
    config.assets.paths << "#{Rails.root}/vendor/fullcalendar"
    config.assets.paths << "#{Rails.root}/vendor/jquery.qtip.custom"
    config.assets.paths << "#{Rails.root}/vendor/zeroclipboard"
  end
end
