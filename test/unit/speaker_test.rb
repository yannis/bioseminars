require 'test_helper'

class SpeakerTest < ActiveSupport::TestCase
  fixtures :all

  should_have_and_belong_to_many :seminars
  
  should_validate_presence_of :name
  
  context "A speaker" do
    setup do
      @speaker = Host.create(:name => 'speaker1 name', :email => 'speaker1@emil.com')
    end

    should "be valid" do
      assert @speaker.valid?, @speaker.errors.full_messages.to_sentence
    end
    
    should "have his name capitalized" do
      assert_equal @speaker.name, 'Speaker1 Name'
    end
  end
end
