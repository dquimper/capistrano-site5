# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set(:deploy_to) { "/home/#{user}/rails/#{application}" }

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :deploy_via, :remote_cache  # if your server has direct access to the repository
#set :deploy_via, :copy  # if you server does NOT have direct access to the repository (default)
set :git_shallow_clone, 1  # only copy the most recent, not the entire repository (default:1)

set :keep_releases, 3  # only keep a current and one previous version to save space

ssh_options[:paranoid] = false

# Necessary to run on Site5
set :use_sudo, false
set :group_writable, false

default_run_options[:pty] = true

set :runner, nil
set :rails_env, "production"

# One other thing that I had problems with (though may not be related to the situation you're having)
# is the set_permissions task in the latest capistrano. It sets g+w on the entire release directory
# which is bad on a shared host (and also causes fcgi processes to fail). To workaround this you can
# override the set_permissions task in your deploy.rb with the following code:
task :set_permissions do
  donothing = true
end

namespace :deploy do
  after "deploy:update", "site5:bundle"

  desc "Site5 version of restart task."
  task :restart do
    site5.restart
  end
end

namespace :site5 do
  desc "Site5 version of restart task."
  task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  desc "runs bundle install --path vendor/bundle."
  task :bundle, :roles => :app do
    run "cd #{current_path}; bundle install --path vendor/bundle"
  end

  desc "#rake db:migrate RAILS_ENV=production"
  task :migrate, :soles => :db do
    #rake db:migrate RAILS_ENV=production
  end
end