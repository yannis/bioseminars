class Person < ActiveRecord::Base
  has_and_belongs_to_many :seminars, :join_table => "people_seminars", :foreign_key => "seminars_id"
  
  validates_presence_of :name
end
