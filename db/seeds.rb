# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
begin
  admin = User.where( email: "yannis.jaquet@unige.ch").first
  member = User.where(email: "gregory.theiler@unige.ch").first
  admin.update_attributes!(email: "admin@bioseminars.unige.ch", password: "12345678", password_confirmation: "12345678", admin: true)
  member.update_attributes!(email: "member@bioseminars.unige.ch", password: "12345678", password_confirmation: "12345678", admin: false)

  # Building.destroy_all
  # cmu = Building.create! name: "CMU"
  # scii = Building.create! name: "SciencesII"
  # sciii = Building.create! name: "SciencesIII"

  # Location.destroy_all
  #   room4059 = Location.create name: "4059", building_id: sciii.id
  #   room4055 = Location.create name: "4055", building_id: sciii.id
  #   room3 = Location.create name: "room 3", building_id: scii.id
  #   room4 = Location.create name: "room 4", building_id: cmu.id
  #   room5 = Location.create name: "room 5", building_id: cmu.id

rescue Exception => e
  p e.message
end
