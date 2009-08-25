set :application, "Seminars"
set :user, 'yannis'
set :scm, :git
# set :run_method, :run
set :ssh_options, { :forward_agent => true }
set :repository,  "ssh://code@129.194.56.197/Users/code/git_repository/seminars/.git"
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

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "rm -fr /Library/Webserver/Documents/seminars; ln -s #{current_path}/public /Library/Webserver/Documents/seminars; touch #{current_path}/tmp/restart.txt"
  end
end
