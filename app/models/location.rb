class Location < ActiveRecord::Base
  # attr_accessor :readable, :updatable, :destroyable
  belongs_to :building
  has_many :seminars, inverse_of: :location

  validates_presence_of :name#, :building_id
  validates_uniqueness_of :name, scope: :building_id

  def name_and_building
    name_and_building = [name]
    name_and_building << "(#{building.name})" if building
    name_and_building.join(" ")
  end
end
