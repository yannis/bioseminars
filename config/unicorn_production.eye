APPLICATION_NAME = 'bioseminars_production'
RUBY = '/Users/yannis/.rbenv/shims' # ruby on the server
APP_PATH = File.expand_path("..", File.dirname(__FILE__))
RAILS_ENV = 'production'
RBENV_VERSION = File.read("#{APP_PATH}/.rbenv-version").strip

# Because:
# - Eye has some really strong problems with proper loading of ENV variables,
# - APP_PATH will be logical location of app (that is: release_path, not current_path)
# we have to enforce APP_PATH to be equal to current_path on environments which are being updated with capistrano.
# APP_PATH = '/Users/yannis/railsapps/bioseminars_production/current'
# APP_PATH = "/u/apps/#{APPLICATION_NAME}/current" if %w[staging production].include?(RAILS_ENV)

Eye.config do
  logger "#{APP_PATH}/log/eye.log"
end


Eye.application APPLICATION_NAME do
  memory_rails_instance_check_options = { every: 1.minute, below: 250.megabytes, times: [3, 5] }
  cpu_rails_instance_check_options = { every: 30.seconds, below: 80, times: [3, 5] }

  working_dir APP_PATH

  env "RAILS_ENV" => RAILS_ENV
  env "RBENV_ROOT" => "/Users/yannis/.rbenv"
  env "RBENV_VERSION" => RBENV_VERSION
  env "PATH" => "/Users/yannis/.rbenv/versions/#{RBENV_VERSION}/bin:#{ENV['PATH']}"
  env "BUNDLE_GEMFILE" => "#{APP_PATH}/Gemfile"

  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 30.seconds, below: 100, times: 3

  process :unicorn do
    pid_file "tmp/pids/bioseminars_production_unicorn.pid"

    start_command "/Users/yannis/.rbenv/shims/bundle exec unicorn -c config/unicorn_production.rb -E production -D"
    # Tell unicorn to finish his current requests, wait a little and then kill it.
    stop_signals [:QUIT, 10.seconds, :TERM]
    # Unicorn will restart the binary itself.
    restart_command "kill -USR2 {PID}"

    start_timeout 30.seconds
    restart_grace 30.seconds

    stdall "log/eye.unicorn.log"

    check :memory, memory_rails_instance_check_options

    monitor_children do
      check :cpu, cpu_rails_instance_check_options
      check :memory, memory_rails_instance_check_options
      stop_command "kill -QUIT {PID}"
    end
  end
end
