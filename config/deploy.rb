set :application, "open-direct-democracy"
set :domain, "beint.lydraedi.is"
set :selected_branch, "master"
set :repository, "git@github.com:rbjarnason/open-direct-democracy.git"
set :use_sudo, false
set :deploy_to, "/home/robert/sites/#{application}/#{selected_branch}"
set :branch, "#{selected_branch}"
set :user, "robert"

set :scm, "git"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

task :after_update_code do
  run "ln -s #{deploy_to}/#{shared_dir}/config/database.yml #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/#{shared_dir}/production #{current_release}/public/production"
  run "ln -s #{deploy_to}/#{shared_dir}/private #{current_release}/private"
  run "rm -f #{current_path}"
end

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

deploy.task :start do
# nothing
end 

