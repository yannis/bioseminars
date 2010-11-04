namespace :cron do
  
  desc "Remove unused hosts"
  task :remove_unused_hosts => :environment do
    puts "Removing unused hosts…"
    for host in Host.all
      if host.hostings.blank?
        Host.destroy(host.id)
        puts '.'
      end
    end
    puts "No more unused host."
  end
end