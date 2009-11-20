require 'seminars_formatted.rb'
namespace :archive do
 desc "Enter buildings"
 task :old_buildings => :environment do
   
   old_buildings = [{:name => 'Sciences III', :description => ''}, {:name => 'CMU', :description => 'Centre Médical Universitaire, Genève'}, {:name => 'Sciences II', :description => ''}, {:name => 'Muséum d''histoire naturelle', :description => ''}]
   
   old_buildings.each do |b|
     Building.find_or_create_by_name(b[:name])
   end
 end
 
 desc "Enter rooms"
 task :old_rooms => :environment do
   
   old_rooms = [{:name => '1069', :description => '', :building_name => "Sciences III"},
     {:name => '1S081', :description => '', :building_name => "Sciences III"},
     {:name => '1S059', :description => '', :building_name => "Sciences III"},
     {:name => '7001', :description => '', :building_name => "CMU"},
     {:name => '2002', :description => '', :building_name => "Sciences II"},
     {:name => '9078', :description => '', :building_name => "CMU"},
     {:name => '4055B', :description => '', :building_name => "Sciences III"},
     {:name => '4055', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4062a', :description => '', :building_name => "Sciences III"},
     {:name => '3005a', :description => '', :building_name => "Sciences III"},
     {:name => '4081c', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '2002a', :description => '', :building_name => "CMU"},
     {:name => '4004', :description => '', :building_name => "Sciences III"},
     {:name => '6140c', :description => '', :building_name => "CMU"},
     {:name => '4013b', :description => '', :building_name => "Sciences III"},
     {:name => '3004b', :description => '', :building_name => "Sciences III"},
     {:name => '3004a', :description => '', :building_name => "Sciences III"},
     {:name => '1013a', :description => '', :building_name => "Sciences III"},
     {:name => '3003a', :description => '', :building_name => "Sciences III"},
     {:name => '4067b', :description => '', :building_name => "Sciences III"},
     {:name => '4024b', :description => '', :building_name => "Sciences III"},
     {:name => '4077b', :description => '', :building_name => "Sciences III"},
     {:name => '4058b', :description => '', :building_name => "Sciences III"},
     {:name => '4037b', :description => '', :building_name => "Sciences III"},
     {:name => 'A100', :description => '', :building_name => "Sciences II"},
     {:name => '4059', :description => '', :building_name => "Sciences III"},
     {:name => '4041', :description => '', :building_name => "Sciences III"},
     {:name => '4003b', :description => '', :building_name => "Sciences III"},
     {:name => '352', :description => '', :building_name => "Sciences II"},
     {:name => '3079', :description => '', :building_name => "Sciences III"},
     {:name => '2024', :description => '', :building_name => "Sciences III"},
     {:name => 'A150', :description => '', :building_name => "Sciences II"},
     {:name => '7172', :description => '', :building_name => "CMU"},
     {:name => 'S3', :description => '', :building_name => "CMU"},
     {:name => 'Seminar room 4-5', :description => '', :building_name => "CMU"},
     {:name => 'A250', :description => '', :building_name => "CMU"},
     {:name => '4082', :description => '', :building_name => "Sciences III"},
     {:name => '4067a', :description => '', :building_name => "Sciences III"},
     {:name => '4055a', :description => '', :building_name => "Sciences III"},
     {:name => '1s004a', :description => '', :building_name => "Sciences III"},
     {:name => '4078', :description => '', :building_name => "Sciences II"},
     {:name => '4036b', :description => '', :building_name => "Sciences III"},
     {:name => '4030', :description => '', :building_name => "Sciences III"},
     {:name => '4078', :description => '', :building_name => "Sciences III"},
     {:name => '2021', :description => '', :building_name => "Sciences III"},
     {:name => '4027', :description => '', :building_name => "Sciences III"},
     {:name => '1s047', :description => '', :building_name => "Sciences III"},
     {:name => '4034', :description => '', :building_name => "Sciences III"},
     {:name => '4054', :description => '', :building_name => "Sciences III"},
     {:name => '3013a', :description => '', :building_name => "Sciences III"},
     {:name => '4013a', :description => '', :building_name => "Sciences III"},
     {:name => '4061a', :description => '', :building_name => "Sciences III"},
     {:name => '0026', :description => '', :building_name => "Sciences III"},
     {:name => '4003c', :description => '', :building_name => "Sciences III"},
     {:name => '4082a', :description => '', :building_name => "Sciences III"},
     {:name => '4077a', :description => '', :building_name => "Sciences III"},
     {:name => '0029b', :description => '', :building_name => "Sciences II"},
     {:name => '4037a', :description => '', :building_name => "Sciences III"},
     {:name => '4022a', :description => '', :building_name => "Sciences III"},
     {:name => '4014a', :description => '', :building_name => "Sciences III"},
     {:name => 'unknown', :description => '', :building_name => "Muséum d'histoire naturelle"},
     {:name => '4002a', :description => '', :building_name => "Sciences III"},
     {:name => '4078b', :description => '', :building_name => "Sciences III"},
     {:name => '4005', :description => '', :building_name => "Sciences III"},
     {:name => '3002', :description => '', :building_name => "Sciences III"},
     {:name => '0034b', :description => '', :building_name => "Sciences III"},
     {:name => '4009', :description => '', :building_name => "Sciences III"},
     {:name => '4013a', :description => '', :building_name => "Sciences III"},
     {:name => '8240', :description => '', :building_name => "CMU"},
     {:name => '223', :description => '', :building_name => "Sciences II"},
     {:name => '4055B', :description => '', :building_name => "Sciences III"},
     {:name => '4055B', :description => '', :building_name => "Sciences III"},
     {:name => 'A50B', :description => '', :building_name => "Sciences II"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '3004a', :description => '', :building_name => "Sciences III"},
     {:name => '3004a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4055B', :description => '', :building_name => "Sciences III"},
     {:name => '4055B', :description => '', :building_name => "Sciences III"},
     {:name => '4078b', :description => '', :building_name => "Sciences III"},
     {:name => '4078b', :description => '', :building_name => "Sciences III"},
     {:name => '4078', :description => '', :building_name => "Sciences II"},
     {:name => '4078', :description => '', :building_name => "Sciences II"},
     {:name => '4013a', :description => '', :building_name => "Sciences III"},
     {:name => '4013a', :description => '', :building_name => "Sciences III"},
     {:name => '4030', :description => '', :building_name => "Sciences III"},
     {:name => '4030', :description => '', :building_name => "Sciences III"},
     {:name => '4024b', :description => '', :building_name => "Sciences III"},
     {:name => '4024b', :description => '', :building_name => "Sciences III"},
     {:name => '0034b', :description => '', :building_name => "Sciences III"},
     {:name => '4041', :description => '', :building_name => "Sciences III"},
     {:name => '4041', :description => '', :building_name => "Sciences III"},
     {:name => '4034', :description => '', :building_name => "Sciences III"},
     {:name => '4034', :description => '', :building_name => "Sciences III"},
     {:name => '3004b', :description => '', :building_name => "Sciences III"},
     {:name => '3004b', :description => '', :building_name => "Sciences III"},
     {:name => '1013a', :description => '', :building_name => "Sciences III"},
     {:name => '1013a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '0034b', :description => '', :building_name => "Sciences III"},
     {:name => '0034b', :description => '', :building_name => "Sciences III"},
     {:name => '4067a', :description => '', :building_name => "Sciences III"},
     {:name => '4078', :description => '', :building_name => "Sciences III"},
     {:name => '4078', :description => '', :building_name => "Sciences III"},
     {:name => '4036b', :description => '', :building_name => "Sciences III"},
     {:name => '4036b', :description => '', :building_name => "Sciences III"},
     {:name => '4022a', :description => '', :building_name => "Sciences III"},
     {:name => '4022a', :description => '', :building_name => "Sciences III"},
     {:name => 'unknown', :description => '', :building_name => "CMU"},
     {:name => '4077b', :description => '', :building_name => "Sciences III"},
     {:name => '4077b', :description => '', :building_name => "Sciences III"},
     {:name => '4037b', :description => '', :building_name => "Sciences III"},
     {:name => '4037b', :description => '', :building_name => "Sciences III"},
     {:name => '3004b', :description => '', :building_name => "Sciences III"},
     {:name => '3004b', :description => '', :building_name => "Sciences III"},
     {:name => '4081c', :description => '', :building_name => "Sciences III"},
     {:name => '4081c', :description => '', :building_name => "Sciences III"},
     {:name => 'A300', :description => '', :building_name => "Sciences II"},
     {:name => '4036b', :description => '', :building_name => "Sciences III"},
     {:name => '4036b', :description => '', :building_name => "Sciences III"},
     {:name => '4013a', :description => '', :building_name => "Sciences III"},
     {:name => '4055a', :description => '', :building_name => "Sciences III"},
     {:name => '4013a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4062a', :description => '', :building_name => "Sciences III"},
     {:name => '4062a', :description => '', :building_name => "Sciences III"},
     {:name => '4037a', :description => '', :building_name => "Sciences III"},
     {:name => '4037a', :description => '', :building_name => "Sciences III"},
     {:name => '0013', :description => '', :building_name => "Sciences III"},
     {:name => 'D60', :description => '', :building_name => "CMU"},
     {:name => '4041', :description => '', :building_name => "Sciences III"},
     {:name => '4041', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4037b', :description => '', :building_name => "Sciences III"},
     {:name => '4037b', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '3004b', :description => '', :building_name => "Sciences III"},
     {:name => '3004b', :description => '', :building_name => "Sciences III"},
     {:name => 'unknown', :description => '', :building_name => "Muséum d'histoire naturelle"},
     {:name => 'unknown', :description => '', :building_name => "Muséum d'histoire naturelle"},
     {:name => '3005a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4027', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4077b', :description => '', :building_name => "Sciences III"},
     {:name => '4077b', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4078', :description => '', :building_name => "Sciences III"},
     {:name => '4023B', :description => '', :building_name => "Sciences III"},
     {:name => '4024a', :description => '', :building_name => "Sciences III"},
     {:name => '4003b', :description => '', :building_name => "Sciences III"},
     {:name => '4003b', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4041', :description => '', :building_name => "Sciences III"},
     {:name => '4041', :description => '', :building_name => "Sciences III"},
     {:name => '4047', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"},
     {:name => '4047a', :description => '', :building_name => "Sciences III"}]
   
   old_rooms.each do |r|
     room = Location.find_or_initialize_by_name(r[:name])
     room.building = Building.find_by_name(r[:building_name])
     room.save
   end
 end
 
 desc "Enter categories"
 task :old_categories => :environment do
   
   old_categories = [
   {:name => 'various', :description => ''},
   {:name => 'Internal Department Seminar', :description => 'Séminaire interne du Dpt'},
   {:name => 'Séminaire de fin de période d''essais', :description => ''},
   {:name => 'Life Science Seminars', :description => ''},
   {:name => 'Biochemistry seminar', :description => ''},
   {:name => 'Seminar in Neuroscience', :description => ''},
   {:name => 'Geneva biology club', :description => ''},
   {:name => 'Molecular biology, cellular biology and biochemistry seminars', :description => ''},
   {:name => 'Geneva Plant Seminar', :description => ''},
   {:name => 'Monday seminars, molecular and cellular biology', :description => ''},
   {:name => 'Thesis defense', :description => ''},
   {:name => 'Dpt of Zoo. seminar', :description => ''},
   {:name => 'Stem Cells and Regenerative Medicine Seminar Series', :description => 'An interdisciplinary approach to stem cell science in Geneva'},
   {:name => 'Chips Club', :description => 'The Chips Club is an informal meeting for the lemanic community (and further...) interested in genomics and more particularly microarrays approaches. This meeting is a great opportunity to share experiences and impressions on hot topics in genomics. From September 2006, the location of the Chips Club meetings will alternate between Lausanne and Geneva'},
   {:name => 'Commercial seminar', :description => ''},
   {:name => 'Stem Cell Soirée', :description => 'An interdisciplinary approach to stem cell science in Geneva'},
   {:name => 'Bicel Technoclub', :description => ''},
   {:name => 'Frontiers in Biology', :description => ''},
   {:name => 'microscopy course', :description => ''},
   {:name => 'Cellular biology seminar', :description => ''},
   {:name => 'Jours du Gène 2008', :description => ''},
   {:name => 'Faculty of Medicine', :description => ''},
   {:name => 'Dpt of Molecular Biology', :description => ''},
   {:name => 'workshop', :description => ''},
   {:name => 'Cycle de conférences en Génétique', :description => ''},
   {:name => 'Conference', :description => ''}
   ]
   
   old_categories.each do |b|
     category = Category.find_or_initialize_by_name(b[:name])
     category.description = b[:description]
     category.save
   end
 end
 
 desc "Enter seminars"
 task :old_seminars => :environment do
   OLD_SEMINARS.each do |s|
     seminar = Seminar.new(:description => s[:description], :start_on => s[:start_on], :end_on => s[:end_on], :internal => false)
     seminar.speakers << Speaker.new(:name => s[:speaker_name], :affiliation => s[:affiliation], :title => s[:title])
     host = Host.find_by_email(s[:host_email])
     host = Host.find_by_name(s[:host_name]) if host.blank?
     host = Host.new(:name => s[:host_name], :email => s[:host_email]) if host.blank?
     seminar.hosts << host
     seminar.category = Category.find_or_initialize_by_name(s[:category_name])
     seminar.location = Location.find_or_initialize_by_name(s[:room_name])
     seminar.user = User.find_by_email('yannis.jaquet@unige.ch')
     unless seminar.save
       puts "seminar #{seminar.speakers.first.title} not saved (#{seminar.errors.full_messages.to_sentence}, #{seminar.speakers.first.errors.full_messages.to_sentence})"
     end
   end
 end
 
 desc "Remove unused categories"
 task :remove_unused_categories => :environment do
   deleted_cats = []
   Category.all.each do |c|
     puts '.'
     if c.seminars.blank? 
       deleted_cats << c.name if Category.delete(c.id)
     end
   end
   if deleted_cats.blank?
     puts "No category deleted"
   else
     puts "Categorie #{deleted_cats.join(', ')} deleted"
   end 
 end
 
  desc "Remove unused locations and buildings"
  task :remove_unused_locations => :environment do
    deleted_locs = []
    deleted_builds = []
    Location.all.each do |c|
      puts '.'
      if c.seminars.blank? 
        deleted_locs << c.name if Location.delete(c.id)
      end
    end
    Building.all.each do |c|
      puts '.'
      if c.locations.blank? 
        deleted_builds << c.name if Building.delete(c.id)
      end
    end
    if deleted_locs.blank?
      puts "No location deleted"
    else
      puts "Locations #{deleted_locs.join(', ')} deleted"
    end
    if deleted_builds.blank?
      puts "No building deleted"
    else
      puts "Buildings #{deleted_builds.join(', ')} deleted"
    end
  end
end
