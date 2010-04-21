class Speaker < ActiveRecord::Base
  belongs_to :seminar
  
  validates_presence_of :name
  validates_presence_of :title
  
  before_validation :capitalize_name
  
  def name_and_affiliation
    name_and_affiliation = [name]
    name_and_affiliation << "(#{affiliation})" unless affiliation.blank?
    #see http://htmlentities.rubyforge.org/
    return HTMLEntities.new.encode(name_and_affiliation.join(' '))
  end
  
  def bold_name_and_affiliation
    name_and_affiliation = ["<strong>#{HTMLEntities.new.encode(name)}</strong>"]
    name_and_affiliation << "(#{HTMLEntities.new.encode(affiliation)})" unless affiliation.blank?
    return name_and_affiliation.join(' ')
  end
  
  private
  
  def capitalize_name
    self.name = self.name.titleize unless self.name.blank?
  end
  
  
end
