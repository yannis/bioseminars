# config valid only for Capistrano 3.1
lock '3.1.0'
set :repo_url, 'git@github.com:yannis/bioseminars.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}
# set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :rbenv_path, "/Users/yannis/.rbenv"
# set :default_environment,           {
#   "PATH" => "/usr/local/bin:/usr/local/sbin:/Users/yannis/.rbenv/shims:/Users/yannis/.rbenv/bin:$PATH"
# }

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.0.0-p451'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} /usr/local/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default value for keep_releases is 5
set :keep_releases, 5
server '129.194.56.70', user: 'yannis', roles: %w{web app db}

task :staging do
  set :stage, 'staging'
  set :rails_env, 'staging'
  set :application, 'bioseminars_staging'
  set :deploy_to, "/var/www/#{fetch(:application)}"
  set :god_unicorn_config, "#{fetch(:deploy_to)}/current/config/unicorn_staging.god"
  set :god_with_path, "/Users/yannis/.rbenv/shims/god"
end


task :production do
  set :stage, 'production'
  set :rails_env, 'production'
  set :application, 'bioseminars_production'
  set :deploy_to, "/var/www/#{fetch(:application)}"
  set :god_unicorn_config, "#{fetch(:deploy_to)}/current/config/unicorn_production.god"
  set :god_with_path, "/Users/yannis/.rbenv/shims/god"
end

namespace :deploy do
  task :restart do
    on roles(:app) do
      execute "kill -s QUIT $(cat #{release_path}/tmp/pids/bioseminars_#{fetch(:stage)}_unicorn.pid)"
    end
  end
end

after "deploy:cleanup", "deploy:restart"
# after "deploy:restart", "airbrake:deploy"
