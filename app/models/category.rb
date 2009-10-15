class Category < ActiveRecord::Base
  has_many :seminars, :dependent => :nullify
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  default_scope :order => 'categories.name ASC'
end
