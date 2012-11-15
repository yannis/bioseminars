require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Seminars
  class Application < Rails::Application


    config.active_record.observers = :seminar_observer, :user_observer
    config.time_zone = 'Bern'
    config.encoding = "utf-8"
    config.filter_parameters += [:password, :password_confirmation]
    # config.action_view.field_error_proc = Proc.new{ |html_tag, instance| "<span class='fieldWithErrors'>#{html_tag}</span>" }

  end


end
