# Set environment to development unless something else is specified
env = "staging"
wd = "/var/www/bioseminars_staging/current/"
working_directory wd
pid "#{wd}tmp/pids/bioseminars_staging_unicorn.pid"
stderr_path "#{wd}log/bioseminars_staging_unicorn.stderr.log"
stdout_path "#{wd}log/bioseminars_staging_unicorn.stdout.log"

listen "#{wd}tmp/sockets/bioseminars_staging_unicorn.sock"
worker_processes 1
timeout 30

# Edit the unicorn.rb to your desire ,it's well commented and please remember to change the port to 8081! NGINX will run on port 8080 with the above nginx.conf, so unicorn cun't run on the same port. The line you have to change for the port should look like this:
# listen 8080, :tcp_nopush => true
listen 8086, :tcp_nopush => true

# Preload our app for more speed
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "/tmp/pids/bioseminars_staging_unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
