class Category < ActiveRecord::Base
  has_many :seminars, :dependent => :nullify
  
  validates :name, :presence => {:message => "can't be blank. Please give this category a name."}, :uniqueness => {:message => "must be unique and this one has already been taken. Please chose another one."}
  validates :acronym, :uniqueness => {:message => "must be unique and this one has already been taken. Please chose another one.", :allow_nil => true}
  
  default_scope :order => 'categories.position ASC, categories.name ASC'
  
  before_validation :set_color
  
  def acronym_or_name
    acronym.blank? ? name : acronym
  end
  
  private
  
  def set_color
    self.color ||= '007E64'
  end
end