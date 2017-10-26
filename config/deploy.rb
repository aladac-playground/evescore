# frozen_string_literal: true

# config valid only for current version of Capistrano
lock '3.9.1'

set :application, 'evescore'
set :repo_url, 'https://github.com/aladac/evescore.git'
set :passenger_in_gemfile, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/rails/evescore'

set :passenger_restart_command, -> { "bundle exec passenger stop --pid-file /tmp/passenger-#{fetch(:application)}.pid #{current_path}; bundle exec passenger start" }
set :passenger_restart_options, -> { "--pid-file /tmp/passenger-#{fetch(:application)}.pid -d -e production #{current_path}" }

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
