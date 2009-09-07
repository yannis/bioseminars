require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
  fixtures :all

  should_have_many :locations, :dependent => :destroy
  
  should_validate_presence_of :name
  should_validate_uniqueness_of :name

end
