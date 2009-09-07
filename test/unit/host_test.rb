require 'test_helper'

class HostTest < ActiveSupport::TestCase
  fixtures :all

  should_have_and_belong_to_many :seminars
  
  should_validate_presence_of :name
end
