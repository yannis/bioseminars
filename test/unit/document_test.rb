require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  
  fixtures :all
  
  should belong_to :model
  # should "have_attached_file :data" do
  #   assert_equal Document.first.model_type, DocumentTest.methods.inspect
  # end
  should have_attached_file :data
  should validate_attachment_presence :data
  should validate_attachment_content_type(:data).
    allowing('application/pdf', 'application/msword', 'text/plain', 'text/rtf').
    rejecting('image/jpeg')
  should validate_attachment_size(:data).less_than(10.megabytes)
end