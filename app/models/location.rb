class Location < ActiveRecord::Base
  belongs_to :building
  has_many :seminars, :dependent => :nullify
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :building_id
  
  default_scope :order => "locations.name ASC"
  named_scope :without_building, :conditions => "locations.building_id IS NULL"
  
  def name_and_building
    name_and_building = [name]
    name_and_building << "(#{building.name})" unless building.blank?
    return name_and_building.join(" ")
  end
end
