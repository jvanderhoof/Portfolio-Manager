require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :stages, %w(staging production) # [optional] defaults to
#set :stages, %w{staging production}
set :default_stage, "staging"

set :application, "personal_investor"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :scm, "git"
set :scm_user, "jvanderhoof"
set :repository,"git@bitbucket.org:jvanderhoof/simplified_investing.git"

set :branch, "master"
#set :deploy_via, :remote_cache

set :user, "deploy"
set :use_sudo, false

after "deploy:finalize_update", "deploy:cleanup"
after "deploy:update_code", :configure_app

task :configure_app, :roles => [:app] do
  # build the asset packages
  #run "cd #{release_path} && rake asset:packager:build_all RAILS_ENV=#{stage}"
  run "cd #{release_path} && bundle exec rake assets:precompile RAILS_ENV=#{stage}"
  # relink database configuration
  #run "cp #{release_path}/config/database.yml.example #{release_path}/config/database.yml"
  # clear the frags directories
  #run "rm -rf #{shared_path}/system/frags"
  #run "mkdir #{shared_path}/system/frags"
  #run "ln -nfs #{shared_path}/system/frags #{release_path}/public/system/frags"
  #run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  #assets:precompile
end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
