require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  should_belong_to :model
  should_have_attached_file :data
end
