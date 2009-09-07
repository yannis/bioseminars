class Category < ActiveRecord::Base
  has_many :seminars, :dependent => :nullify
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
