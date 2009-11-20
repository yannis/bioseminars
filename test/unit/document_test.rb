require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  fixtures :all
  
  should_belong_to :model
  should_have_attached_file :data
  should_validate_attachment_presence :data
  should_validate_attachment_content_type :data, :valid => ['application/pdf', 'application/msword', 'text/plain', 'text/rtf'], :invalid => ['image/jpeg']
  should_validate_attachment_size :data, :less_than => 10.megabytes
end
