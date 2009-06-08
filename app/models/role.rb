class Role < ActiveRecord::Base
  has_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  default_scope :order => "roles.name ASC"
  
  def to_s
    name
  end
end