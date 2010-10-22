class Hosting < ActiveRecord::Base
  belongs_to :host
  belongs_to :seminar
  
  validates :host_id, :presence => true
end
