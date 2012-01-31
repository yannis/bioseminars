ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "paperclip/matchers"
require 'capybara'
require 'capybara/dsl'

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

# Speed up paperclip tests (http://jstorimer.com/ruby/2010/01/05/speep-up-your-paperclip-tests.html)
class Picture
  before_post_process do |image|
    false # halts processing
  end
end

module ActionDispatch
  class IntegrationTest
    include Capybara::DSL
  end
end