class Building < ActiveRecord::Base
  
  has_many :locations, :dependent => :destroy
  has_many :seminars, :through => :locations
  
  validates :name, :presence => {:message => "can't be blank. Please give this building a name."}, :uniqueness => {:message => "must be unique and this one has already been taken. Please chose another one."}
end
