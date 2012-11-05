puts "-- -- staging -- --"
role :web, "www.simplifiedinvesting.net"
role :app, "www.simplifiedinvesting.net"
role :db,  "www.simplifiedinvesting.net", :primary => true

set :host, "www.simplifiedinvesting.net"
set :application, "personal_investor_staging"
set :deploy_to, "/home/deploy/rails/personal_investor_staging"

set :user, "deploy"

set :stage, "staging"  
ENV['RAILS_ENV'] = stage 
set :env, stage
set :environment, env 
set :rails_env, stage

after "deploy:update_code", :staging_config
desc "Set the Staging robots.txt file and Re-generate sitemap after deployment"
task :staging_config, :roles => [:app, :db, :web] do
  #run "rm #{release_path}/public/robots.txt"
  #run "cp #{release_path}/public/robots_staging.txt #{release_path}/public/robots.txt"
  #run "cd #{current_path} && rake brewershub:dynamic_sitemap RAILS_ENV=staging"
end
