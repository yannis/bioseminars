class Speaker < ActiveRecord::Base
  has_and_belongs_to_many :seminars
  
  validates_presence_of :name, :title
  
  before_validation :capitalize_name
  
  private
  
  def capitalize_name
    self.name = self.name.titleize unless self.name.blank?
  end
  
  
end
