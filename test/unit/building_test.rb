require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
  fixtures :all

  should_have_many :locations, :dependent => :destroy
  
  should_validate_presence_of :name, :message => "can't be blank. Please give this building a name."
  should_validate_uniqueness_of :name, :message => "must be unique and this one has already been taken. Please chose another one."

end
