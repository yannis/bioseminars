class Building < ActiveRecord::Base
  has_many :locations, :dependent => :destroy
  has_many :seminars, :through => :locations
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
