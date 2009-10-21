class Speaker < ActiveRecord::Base
  has_and_belongs_to_many :seminars
  
  validates_presence_of :name, :title
  
  before_validation :capitalize_name
  
  def name_and_affiliation
    name_and_affiliation = [name]
    name_and_affiliation << "(#{affiliation})" unless affiliation.blank?
    return name_and_affiliation.join(' ')
  end
  
  def bold_name_and_affiliation
    name_and_affiliation = ["<strong>#{name}</strong>"]
    name_and_affiliation << "(#{affiliation})" unless affiliation.blank?
    return name_and_affiliation.join(' ')
  end
  
  private
  
  def capitalize_name
    self.name = self.name.titleize unless self.name.blank?
  end
  
  
end
