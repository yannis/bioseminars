require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  fixtures :all
  
  should belong_to :building
  should have_many(:seminars).dependent(:nullify)

  should validate_presence_of(:name).with_message("can't be blank. Please give this location a name.")
  should validate_uniqueness_of(:name).scoped_to(:building_id).with_message("must be unique and this one has already been taken. Please chose another one.")
  
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