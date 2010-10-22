require 'test_helper'

class HostTest < ActiveSupport::TestCase

  should have_many :hostings
  should have_many(:seminars).through(:hostings)
  
  should validate_presence_of :name
  should validate_presence_of :email
  
  context "A host" do
    setup do
      @host = Factory :host, :name => 'host1 NAME'
    end
    
    should validate_uniqueness_of :name
    should validate_uniqueness_of :email

    should "be valid" do
      assert @host.valid?, @host.errors.full_messages.to_sentence
    end
    
    should "have his name capitalized" do
      assert_equal @host.name, 'Host1 Name'
    end
  end
end

