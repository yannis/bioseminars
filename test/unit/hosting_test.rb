require 'test_helper'

class HostingTest < ActiveSupport::TestCase

  should belong_to :host
  should belong_to :seminar
  
  should validate_presence_of :host_id
  
  context "A hosting" do
    setup do
      @hosting = Factory :hosting
    end

    should "be valid" do
      assert @hosting.valid?, @hosting.errors.full_messages.to_sentence
    end
  end
end

