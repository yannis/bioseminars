require 'paperclip'
class Document < ActiveRecord::Base
  belongs_to :model, :polymorphic => true
  has_attached_file :data
  validates_attachment_presence :data
  validates_attachment_content_type :data, :content_type => ['application/pdf', 'application/msword', 'text/plain', 'text/rtf', 'application/vnd.ms-excel']
  validates_attachment_size :data, :less_than => 10.megabytes
end
