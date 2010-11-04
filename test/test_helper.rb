ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "paperclip/matchers"
require 'webrat'
require 'webrat/core/matchers' 

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess # to allow file upload
  include Paperclip::Shoulda::Matchers
  fixtures :all 
end


Webrat.configure do |config|
  config.mode = :rails
end

class Test::Unit::TestCase
 extend  Paperclip::Shoulda::Matchers
end

class ActionController::TestCase
  include Devise::TestHelpers
end

# Speed up paperclip tests (http://jstorimer.com/ruby/2010/01/05/speep-up-your-paperclip-tests.html)
class Picture
  before_post_process do |image|
    false # halts processing
  end
end