# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :passenger_restart_with_touch, true
set :stages, ["production", "development"]
set :default_stage, "production"

set :application, "webtecmaster"
set :repo_url, "git@gitlab.com:djosino/webtecmaster.git"

set :migration_role, :app

set :assets_roles, [:web, :app]
set :rails_assets_groups, :assets
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}
set :keep_assets, 2

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/webtecmaster"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/arquivos', 'public/documentos'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :app do
  desc "Restart Project"
  task :restart do
    run_locally do
      execute :touch, 'tmp/restart.txt'
    end
  end
end

namespace :git do
  desc "GitPull for project"
  task :pull do
    on roles(:app), in: :groups, limit: 1 do 
      execute 'git pull'
    end
  end
end


after "deploy:updated", "deploy:compile_assets"
