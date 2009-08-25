class Location < ActiveRecord::Base
  belongs_to :building
  has_many :seminars
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :building_id
  
  def name_and_building
    return "#{name} (#{building.name})"
  end
end
