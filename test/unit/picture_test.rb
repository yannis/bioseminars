require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  should_belong_to :model
  should_validate_attachment_presence :data
  should_validate_attachment_content_type :data, :valid => [/image/], :invalid => ['application/msword']
  should_validate_attachment_size :data, :less_than => 10.megabytes
end



# belongs_to :model, :polymorphic => true
# has_attached_file :data, :styles => {:original => "800", :medium => "300x300>", :thumb => "50x50#" }
# validates_attachment_presence :data
# validates_attachment_content_type :data, :content_type => /image/