class Location < ActiveRecord::Base
  belongs_to :building
  has_many :seminars, :dependent => :nullify
  
  validates :name, :presence => {:message => "can't be blank. Please give this location a name."}, :uniqueness => {:scope => :building_id, :message => "must be unique and this one has already been taken. Please chose another one."}
  
  default_scope includes('building').order("locations.name ASC")
  scope :without_building, where("locations.building_id IS NULL")
  
  before_destroy :no_more_seminars?
  
  def name_and_building
    name_and_building = [name]
    name_and_building << "(#{building.name})" unless building.blank?
    return name_and_building.join(" ")
  end
  
  def no_more_seminars?
    self.seminars.blank?    
  end
end
