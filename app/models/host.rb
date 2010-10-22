class Host < ActiveRecord::Base
  has_many :hostings
  has_many :seminars, :through => :hostings
  
  validates :name, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => {:allow_nil => true}, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  
  before_validation :capitalize_name
  
  default_scope :order => 'hosts.name ASC'
    
  def no_more_seminars?
    seminars.blank?    
  end
  
  private
  
  def capitalize_name
    self.name = self.name.titleize unless self.name.blank?
  end
end
