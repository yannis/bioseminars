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

Factory.define :document do |i|
  # i.attach  :data, "/test/fixtures/files/30_278_H.pdf", "application/pdf" 
  i.data File.new("#{Rails.root}/test/fixtures/files/30_278_H.pdf")
  i.association :model, :factory => :seminar
end

Factory.define :host do |i|
  i.name { 'host_'+Factory.next(:name) }
  i.email { |h| 'host_'+Factory.next(:name)+'@email.com' }
end

Factory.define :hosting do |i|
  i.association :host
  i.association :seminar
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
  i.association :building
end

Factory.define :picture do |i|
  # i.attach  :data, "/test/fixtures/files/30_278_H.pdf", "application/pdf" 
  i.data File.new("#{Rails.root}/test/fixtures/files/rails.png")
  i.association :model, :factory => :seminar
end

Factory.define :seminar do |s|
  s.title { 'seminar_'+Factory.next(:name) }
  s.association :category
  s.association :location
  s.association :user
  s.speakers{ |a| [a.association :speaker]}
  s.hostings_attributes {{:one => {:host_id => Factory(:host).id}}}
  s.start_on{ 2.weeks.since}
end

# Factory.define :seminar_with_hostings, :parent => :seminar do |i|
#   i.after_build { |a| Factory(:hosting, :seminar => a)}
# end

Factory.define :user do |u|
  u.name {'Name_'+Factory.next(:name)}
  u.email {'email_'+Factory.next(:name)+'@unige1.ch'}
  u.password {'password_'+Factory.next(:name)}
  u.password_confirmation {|a| a.password}
end