# if ENV['DEPLOY'] == 'PRODUCTION'
set :domain, "129.194.57.17"
# elsif ENV['DEPLOY'] == 'STAGING'
#    puts "*** Deploying to the STAGING server!"
#    set :domain, "129.194.56.197"
# end
set :application, "bioSeminars"
set :user, 'yannis'
set :scm, :git
# set :run_method, :run
set :ssh_options, { :forward_agent => true }
set :repository,  "ssh://code@129.194.56.197/Users/code/git_repository/seminars/.git"
set :use_sudo, false



# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/Users/yannis/capistrano/bioseminars"
set :branch, "master"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# runtime dependencies
depend :remote, :gem, "bundler", ">=1.0.0.rc.2"

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc <<-DESC
    Starts the application servers. \
    Please note that this task is not supported by Passenger server.
  DESC
  task :start, :roles => :app do
    logger.info ":start task not supported by Passenger server"
  end

  desc <<-DESC
    Stops the application servers. \
    Please note that this task is not supported by Passenger server.
  DESC
  task :stop, :roles => :app do
    logger.info ":stop task not supported by Passenger server"
  end
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
