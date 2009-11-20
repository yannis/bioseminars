class Host < ActiveRecord::Base
  has_and_belongs_to_many :seminars
  
  validates_presence_of :name, :email
  validates_uniqueness_of :name, :allow_nil => true
  validates_uniqueness_of :email, :allow_nil => true
  
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
