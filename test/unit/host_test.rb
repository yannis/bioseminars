require 'test_helper'

class HostTest < ActiveSupport::TestCase

  should_have_and_belong_to_many :seminars
  
  should_validate_presence_of :name
  should_validate_presence_of :email
  # should_validate_uniqueness_of :name
  # should_validate_uniqueness_of :email
  
  context "A host" do
    setup do
      @host = Host.create(:name => 'host1 NAME', :email => 'host1@emil.com')
    end

    should "be valid" do
      assert @host.valid?, @host.errors.full_messages.to_sentence
    end
    
    should "have his name capitalized" do
      assert_equal @host.name, 'Host1 Name'
    end
  end
end

