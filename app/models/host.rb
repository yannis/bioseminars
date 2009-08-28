class Host < ActiveRecord::Base
  has_and_belongs_to_many :seminars
  
  validates_presence_of :name
end
