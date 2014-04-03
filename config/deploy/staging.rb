# set :stage, 'staging'
# set :rails_env, 'staging'
# set :application, 'gde_staging'
# set :deploy_to, "/var/www/#{fetch(:application)}"
# set :god_unicorn_config, "#{fetch(:deploy_to)}/current/config/unicorn_staging.god"

# server '129.194.56.70', user: 'yannis', roles: %w{web app db}

# # you can set custom ssh options
# # it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# # you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# # set it globally
# #  set :ssh_options, {
# #    keys: %w(/home/rlisowski/.ssh/id_rsa),
# #    forward_agent: false,
# #    auth_methods: %w(password)
# #  }
# # and/or per server
# # server 'example.com',
# #   user: 'user_name',
# #   roles: %w{web app},
# #   ssh_options: {
# #     user: 'user_name', # overrides user setting above
# #     keys: %w(/home/user_name/.ssh/id_rsa),
# #     forward_agent: false,
# #     auth_methods: %w(publickey password)
# #     # password: 'please use keys'
# #   }
# # setting per server overrides global ssh_options


# namespace :deploy do
#   task :stop do
#     on roles(:app) do
#       run "god stop gde_staging_unicorn"
#     end
#   end
#   task :reload_god_config do
#     on roles(:app) do
#       puts current_path
#       run "god load #{god_unicorn_config}"
#     end
#   end
#   task :start do
#     on roles(:app) do
#       run "god start gde_staging_unicorn"
#     end
#   end
#   task :stop_reload_start do
#     stop
#     reload_god_config
#     start
#   end
# end

# after "deploy:cleanup", "deploy:stop_reload_start"
