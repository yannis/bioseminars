require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  fixtures :all
  
  should_belong_to :building
  should_have_many :seminars, :dependent => :nullify

  should_validate_presence_of :name
  should_validate_uniqueness_of :name, :scoped_to => :building_id
  
  context 'A location in the database' do
    setup do
      @building = Building.create(:name => 'SCIII')
      @location = @building.locations.create(:name => 'room 4059')
    end
    
    should 'be valid' do
      assert @location.valid?, @location.errors.full_messages
    end
    
    should "have name_and_building == 'room 4059 (SCIII)'" do
      assert_equal @location.name_and_building, 'room 4059 (SCIII)'
    end
  end
end