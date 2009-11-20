class Category < ActiveRecord::Base
  has_many :seminars, :dependent => :nullify
  
  validates_presence_of :name, :message => "can't be blank. Please give this category a name."
  validates_uniqueness_of :name, :message => "must be unique and this one has already been taken. Please chose another one."
  validates_uniqueness_of :acronym, :message => "must be unique and this one has already been taken. Please chose another one.", :allow_nil => true
  
  default_scope :order => 'categories.position ASC, categories.name ASC'
  
  before_validation :set_color
  
  def acronym_or_name
    acronym.blank? ? name : acronym
  end

  def no_more_seminars?
    self.seminars.blank?    
  end
  
  private
  
  def set_color
    self.color ||= '007E64'
  end
end