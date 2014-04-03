require 'biosem1_conversion'
namespace :bioseminars1_transfer do

  desc "transfer all bioseminars data"
  task :clear_all => :environment do
    Rake::Task["db:migrate"].invoke
    begin
      Building.destroy_all
      Category.destroy_all
      Categorisation.destroy_all
      Document.destroy_all
      Hosting.destroy_all
      Host.destroy_all
      Location.destroy_all
      Seminar.destroy_all
      User.destroy_all
    rescue Exception => e
      puts "unable to transfer bioSeminars data"
      if e
        puts e.message
        puts "BACKTRACE"
        puts e.backtrace
      end
    end
  end

  desc "transfer all bioseminars data"
  task :all => :environment do
    Rake::Task["db:migrate"].invoke
    begin
      User.transaction do
        BioSeminars1.transfer_buildings
        BioSeminars1.transfer_users
        BioSeminars1.transfer_locations
        BioSeminars1.transfer_categories
        BioSeminars1.transfer_hosts
      end
    rescue Exception => e
      puts "unable to transfer bioSeminars data"
      if e
        puts e.message
        puts "BACKTRACE"
        puts e.backtrace
      end
    end
  end

  desc "transfer bioseminars seminars"
  task :seminars => :environment do
    Rake::Task["db:migrate"].invoke
    begin
      User.transaction do
        BioSeminars1.transfer_seminars
      end
    rescue Exception => e
      puts "unable to transfer bioSeminars seminars"
      if e
        puts e.message
        puts "BACKTRACE"
        puts e.backtrace
      end
    end
  end

  desc "transfer bioseminars buildings"
  task :buildings => :environment do
    begin
      User.transaction do
        BioSeminars1.transfer_buildings
      end
    rescue Exception => e
      puts "unable to transfer bioSeminars buildings"
      if e
        puts e.message
        puts "BACKTRACE"
        puts e.backtrace
      end
    end
  end

  desc "transfer bioseminars locations"
  task :locations => :environment do
    begin
      User.transaction do
        BioSeminars1.transfer_locations
      end
    rescue Exception => e
      puts "unable to transfer bioSeminars locations"
      if e
        puts e.message
        puts "BACKTRACE"
        puts e.backtrace
      end
    end
  end

  desc "transfer bioseminars categories"
  task :categories => :environment do
    begin
      User.transaction do
        BioSeminars1.transfer_categories
      end
    rescue Exception => e
      puts "unable to transfer bioSeminars categories"
      if e
        puts e.message
        puts "BACKTRACE"
        puts e.backtrace
      end
    end
  end

  desc "transfer bioseminars hosts"
  task :hosts => :environment do
    begin
      User.transaction do
        BioSeminars1.transfer_hosts
      end
    rescue Exception => e
      puts "unable to transfer bioSeminars hosts"
      if e
        puts e.message
        puts "BACKTRACE"
        puts e.backtrace
      end
    end
  end
end
