set :application, "Seminars"
set :user, 'yannis'
set :scm, :git
# set :run_method, :run
set :ssh_options, { :forward_agent => true }
set :repository,  "ssh://yannis@129.194.56.197/Users/yannis/gitrepos/seminars/.git"
set :domain, "129.194.56.197"


# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/Users/yannis/capistrano/seminars"
set :branch, "master"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# default_run_options[:pty] = true

# your svn username and password
# set :svn_username, "yannis"
# set :svn_password, "2375"
set :mongrel_cmd, "mongrel_rails_persist" 
set :mongrel_ports, 3001..3004

namespace :deploy do 
  desc "Start Mongrels processes and add them to launchd." 
  task :start, :roles => :app do 
    mongrel_ports.each do |port| 
      sudo "#{mongrel_cmd} start -p #{port} -e production -c #{current_path}" 
    end 
  end 
  desc "Stop Mongrels processes and remove them from launchd." 
  task :stop, :roles => :app do 
    mongrel_ports.each do |port| 
      sudo "#{mongrel_cmd} stop -p #{port}" 
    end 
  end 
  desc "Restart Mongrel processes" 
  task :restart, :roles => :app do 
    stop 
    start 
  end 
 
end