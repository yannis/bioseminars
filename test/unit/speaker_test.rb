require 'test_helper'

class SpeakerTest < ActiveSupport::TestCase
  fixtures :all

  should belong_to :seminar
  should validate_presence_of :name
  should validate_presence_of :title
  
  context "A speaker" do
    setup do
      @speaker = Factory(:speaker, :name => 'speaker1 NAME', :email => 'speaker1@emil.com', :affiliation => 'IFOM-FIRC, University of Milan, Italy', :title => 'Alternative activation of SREBP in Drosophila')
    end

    should "be valid" do
      assert @speaker.valid?, @speaker.errors.full_messages.to_sentence
    end
    
    should "have his name capitalized" do
      assert_equal @speaker.name, 'Speaker1 Name'
    end
    
    should "have name_and_affiliation" do
      assert_equal @speaker.name_and_affiliation, 'Speaker1 Name (IFOM-FIRC, University of Milan, Italy)'
    end

    should "have bold_name_and_affiliation" do
      assert_equal @speaker.bold_name_and_affiliation, '<strong>Speaker1 Name</strong> (IFOM-FIRC, University of Milan, Italy)'
    end
  end
end
