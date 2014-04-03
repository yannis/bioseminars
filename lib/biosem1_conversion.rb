require 'paperclip'
def connection_data
  {
    :adapter  => "mysql2",
    :host     => "localhost",
    :username => "yannis",
    :password => "2375",
    :database => "bioseminars_development"
  }
end

class Sem1Building < ActiveRecord::Base
  self.table_name = 'buildings'
  establish_connection connection_data
end

class Sem1Category < ActiveRecord::Base
  self.table_name = 'categories'
  establish_connection connection_data

  def new_color
    col = (color ? "##{color}" : "#%06x" % (rand * 0xffffff))
    if Category.where(color: col).first.present? || !(color =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i)
      col = "#%06x" % (rand * 0xffffff)
    end
    return col
  end

  def new_acronym
    if acronym.present?
      return acronym
    else
      words = name.split(" ")
      if words.size >=3
        return words.map{|w| w.first}.join.upcase
      else
        return (words.map{|w| w.first}.join+words.last[1..4]).upcase
      end
    end
  end
end

class Sem1Document < ActiveRecord::Base
  self.table_name = 'documents'
  establish_connection connection_data
  belongs_to :model, polymorphic: true
  # has_attached_file :data, path: "/Users/yannis/railsapps/bioseminars/public/system/data/:id/:style/:filename", url: "/Users/yannis/railsapps/bioseminars/public/system/data/:id/:style/:filename"
end

class Sem1Host < ActiveRecord::Base
  self.table_name = 'hosts'
  establish_connection connection_data
end

class Sem1Hosting < ActiveRecord::Base
  self.table_name = 'hostings'
  establish_connection connection_data
  belongs_to :host, class_name: "Sem1Host", foreign_key: "host_id"
  belongs_to :seminar, class_name: "Sem1Seminar", foreign_key: "seminar_id"
end

class Sem1Location < ActiveRecord::Base
  self.table_name = 'locations'
  establish_connection connection_data
  belongs_to :building, class_name: "Sem1Building", foreign_key: "building_id"

  def new_building
    Building.where(name: building.name).first
  end
end

# class Sem1Picture < ActiveRecord::Base
#   self.table_name = 'pictures'
#   establish_connection connection_data
# end

class Sem1Seminar < ActiveRecord::Base
  self.table_name = 'seminars'
  establish_connection connection_data

  belongs_to :user, class_name: "Sem1User", foreign_key: "user_id"
  belongs_to :category, class_name: "Sem1Category", foreign_key: "category_id"
  belongs_to :location, class_name: "Sem1Location", foreign_key: "location_id"


  has_many :sem1_documents, class_name: "Sem1Document", :as => :model
  has_many :speakers, class_name: "Sem1Speaker", foreign_key: "seminar_id"
  has_many :hostings, class_name: "Sem1Hosting", foreign_key: "seminar_id"
  has_many :hosts, class_name: "Sem1Host", :through => :hostings

  def main_user
    User.where(email: "yannis.jaquet@unige.ch").first_or_create do |u|
      u.name = "Yannis"
      u.password = Devise.friendly_token.first(15)
      u.admin = true
    end
  end

  def new_title
    speakers.first.title.presence || "ND"
  end

  def new_speaker_name
    speakers.first.name
  end

  def new_speaker_affiliation
    speakers.first.try(:affiliation).presence || "Unknown"
  end

  def new_categories
    cat_name = category.try(:name) || "unknown"
    new_category = Category.where( name: cat_name).first_or_create do |c|
      c.description = category.description
      c.color = category.new_color
      c.acronym = category.new_acronym
      c.position = category.position
    end
  end

  def new_categorisations_attributes
    categorisations_attributes = {}
    Array(new_categories).each_with_index do |c, i|
      categorisations_attributes["categorisation#{i}"] = {category_id: c.id}
    end
    return categorisations_attributes
  end

  def new_documents_attributes
    old_documents = Sem1Document.where(model_id: self.id)
    new_documents_attributes = {}
    # old_documents.each_with_index do |c, i|
    #   new_documents_attributes["document#{i}"] = {data: File.new(c.data.path)}
    # end
    p new_documents_attributes if new_documents_attributes.present?
    return new_documents_attributes
  end

  # def new_building
  #   Building.find_by name: location.building.name
  # end

  def new_hosts
    hosts.map{|h| Host.where(email: h.email).first_or_create{|a| a.name = h.name}}
  end

  def new_hostings_attributes
    hostings_attributes = {}
    new_hosts.each_with_index do |h, i|
      hostings_attributes["hosting#{i}"] = {host_id: h.id}
    end
    return hostings_attributes
  end

  def new_location
    if location
      building = Building.where(name: location.building.name).first_or_create
      Location.where(name: location.name, building_id: building.id).first_or_create
    else
      building = Building.where(name: "unknown").first_or_create
      Location.where(name: "unknown", building_id: building.id).first_or_create
    end
  end

  def new_user
    if user
      User.where(email: self.user.email).first_or_create do |u|
        u.name = user.name
        u.password = Devise.friendly_token.first(15)
        u.admin = user.admin
      end
    else
      main_user
    end
  end

  def new_params
    {
      title: new_title,
      speaker_name: new_speaker_name,
      speaker_affiliation: new_speaker_affiliation,
      start_at: start_on,
      end_at: end_on,
      url: url,
      internal: internal,
      all_day: all_day,
      pubmed_ids: pubmed_ids,
      location_id: new_location.id,
      user_id: new_user.id,
      hostings_attributes: new_hostings_attributes,
      categorisations_attributes: new_categorisations_attributes,
      documents_attributes: new_documents_attributes
    }
  end

  def new_create!
    if speakers.size > 1
      p "This is a conference"
    else
      sem = Seminar.new(new_params)
      begin
        sem.save!
      rescue Exception => e
        p "Seminar #{id}: #{e.message}"
      end
    end
  end
end

class Sem1Speaker < ActiveRecord::Base
  self.table_name = 'speakers'
  establish_connection connection_data
end

class Sem1User < ActiveRecord::Base
  self.table_name = 'users'
  establish_connection connection_data
end

class BioSeminars1

  def self.transfer_users
    puts "Transfering bioSeminars1 users"
    User.destroy_all
    User.transaction do
      Sem1User.all.each do |u1|
        password = Devise.friendly_token.first(15)
        print "." if User.create!(name: u1.name, email: u1.email, password: password, admin: u1.admin)
      end
      puts "Users transferred"
    end
  end

  def self.transfer_buildings
    puts "Transfering bioSeminars1 buildings"
    Building.transaction do
      Sem1Building.all.each do |b1|
        print "." if Building.find_or_create_by!(name: b1.name)
      end
      puts "Buildings transferred"
    end
  end

  def self.transfer_locations
    puts "Transfering bioSeminars1 locations"
    Location.transaction do
      Sem1Location.all.each do |l1|
        print "." if Location.find_or_create_by!(name: l1.name, building_id: l1.new_building.id)
      end
      puts "Locations transferred"
    end
  end

  def self.transfer_categories
    puts "Transfering bioSeminars1 categories"
    Category.transaction do
      Sem1Category.all.each do |c1|
        print "." if Category.find_or_create_by!(name: c1.name, description: c1.description, color: c1.new_color, acronym: c1.new_acronym, position: c1.position)
      end
      puts "Categories transferred"
    end
  end

  def self.transfer_hosts
    puts "Transfering bioSeminars1 hosts"
    Host.transaction do
      Sem1Host.all.each do |h1|
        print "." if Host.find_or_create_by!(name: h1.name, email: h1.email)
      end
      puts "Hosts transferred"
    end
  end

  def self.transfer_seminars
    puts "Transfering bioSeminars1 seminars"
    Seminar.transaction do
      Sem1Seminar.all.each do |s1|
        print "." if s1.new_create!
      end
      puts "Seminars transferred"
    end
  end
end
