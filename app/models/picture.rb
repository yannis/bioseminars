class Picture < ActiveRecord::Base
  belongs_to :model, :polymorphic => true
  has_attached_file :data, :styles => {:original => "800", :medium => "300x300>", :thumb => "50x50#" }
  validates_attachment_presence :data
  validates_attachment_content_type :data, :content_type => /image/ 
end
