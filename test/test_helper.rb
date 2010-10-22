ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "paperclip/matchers"

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess # to allow file upload
  include Paperclip::Shoulda::Matchers
  fixtures :all
end

class Test::Unit::TestCase
 extend  Paperclip::Shoulda::Matchers
end

class ActionController::TestCase
  include Devise::TestHelpers
end