# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'mandate.kev.cool'
set :repo_url, 'https://github.com/kmcphillips/mandate_industries.git'

set :user, "deploy"
set :rbenv_ruby, "2.6.0"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/credentials/production.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/.well-known'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

# Unicorn
# set :unicorn_pid, -> { File.join(current_path, "tmp", "pids", "unicorn.pid") }
set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }
# set :unicorn_roles, -> { :app }
# set :unicorn_options, -> { "" }
# set :unicorn_rack_env, -> { fetch(:rails_env) == "development" ? "development" : "deployment" }
# set :unicorn_restart_sleep_time, 3