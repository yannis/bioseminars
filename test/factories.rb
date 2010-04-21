# define an incremental username
Factory.sequence :name do |n|
  "#{n}" 
end

Factory.sequence :user_email do |n|
  "email_#{n}@email.com" 
end

Factory.define :category do |i|
  i.name { 'cat_'+Factory.next(:name) }
  i.description 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
  i.color   rand(999999).to_s
  i.acronym { 'acro_'+Factory.next(:name) }
end

Factory.define :host do |i|
  i.name { 'host_'+Factory.next(:name) }
  i.email { |h| h.name+'@email.com' }
end

Factory.define :speaker do |i|
  i.name { 'speaker_'+Factory.next(:name) }
  i.affiliation { 'affiliation_'+Factory.next(:name) }
  i.title { 'title_'+Factory.next(:name) }
end

Factory.define :building do |i|
  i.name { 'building_'+Factory.next(:name) }
end

Factory.define :location do |i|
  i.name {'location_'+Factory.next(:name)}
  i.building {|a| a.association(:building) }
end


Factory.define :seminar do |s|
  s.title { 'seminar_'+Factory.next(:name) }
  s.category {|a| a.association(:category) }
  s.location {|a| a.association(:location) }
  s.speakers{ |a| [a.association :speaker]}
  s.hosts{ |a| [a.association :host]}
  s.start_on{ 2.weeks.since}
end