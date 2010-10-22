require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
  fixtures :all

  should have_many(:locations).dependent(:destroy)
  
  should validate_presence_of(:name).with_message("can't be blank. Please give this building a name.")
  should validate_uniqueness_of(:name).with_message("must be unique and this one has already been taken. Please chose another one.")
end
