require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  should belong_to :model
  should validate_attachment_presence :data
  should validate_attachment_content_type(:data).
    allowing(/image/).
    rejecting('application/msword')
  should validate_attachment_size(:data).less_than(10.megabytes)
end