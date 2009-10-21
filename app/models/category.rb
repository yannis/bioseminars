class Category < ActiveRecord::Base
  has_many :seminars, :dependent => :nullify
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  default_scope :order => 'categories.name ASC'
  
  before_validation :set_color
  
  def acronym_or_name
    acronym.blank? ? name : acronym
  end
  
  private
  
  def set_color
    self.color ||= '#007E64'
  end
end
