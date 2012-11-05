puts "-- -- production -- --"
role :web, "www.simplifiedinvesting.net"
role :app, "www.simplifiedinvesting.net"
role :db,  "www.simplifiedinvesting.net", :primary => true

set :host, "www.simplifiedinvesting.net"
set :application, "personal_investor_production"
set :deploy_to, "/home/deploy/rails/personal_investor_production"

set :user, "deploy"

set :stage, "production"
ENV['RAILS_ENV'] = stage
set :env, stage
set :environment, env
set :rails_env, stage

after "deploy:update_code", :production_config
desc "Re-generate sitemap after deployment"
task :production_config, :roles => [:app, :db, :web] do
  #run "cd #{current_path} && rake brewershub:dynamic_sitemap RAILS_ENV=production"
end
