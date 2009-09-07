require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  fixtures :all
  
  should_have_many :users, :dependent => :nullify

  should_validate_presence_of :name
  should_validate_uniqueness_of :name
end