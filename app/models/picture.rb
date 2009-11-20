class Picture < ActiveRecord::Base
  belongs_to :model, :polymorphic => true
  has_attached_file :data, :styles => {:original => "800", :medium => "300x300>", :thumb => "50x50#" }
  validates_attachment_presence :data
  validates_attachment_content_type :data, :content_type => /image/
  validates_attachment_size :data, :less_than => 10.megabytes
end
