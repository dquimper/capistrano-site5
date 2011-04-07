set(:deploy_to) { "/home/#{user}/rails/#{application}" }
set(:public_html) { "/home/#{user}/public_html/#{application}"}

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
  after "deploy:setup", "site5:setup"
  after "deploy:check", "site5:check"
  after "deploy:symlink", "site5:htaccess_setup"

  desc "Site5 version of restart task."
  task :restart do
    site5.restart
  end
end

namespace :site5 do
  after "site5:bundle", "site5:migrate"

  desc "Site5 version of restart task."
  task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  desc "runs bundle install --path vendor/bundle."
  task :bundle, :roles => :app do
    run "cd #{current_path}; bundle install --path vendor/bundle"
  end

  desc "#rake db:migrate RAILS_ENV=production"
  task :migrate, :roles => :db do
    #rake db:migrate RAILS_ENV=production
  end

  task :htaccess_setup, :roles => :app do
    htaccess = "#{public_html}/.htaccess"
    run "if [ ! -f #{htaccess} ]; then echo 'PassengerEnabled On' > #{htaccess}; echo 'PassengerAppRoot #{current_path}'; echo '.htaccess created' >> #{htaccess}; else echo '.htaccess already exists (untouched)'; fi"
  end

  desc "Set your public_html to point to your project's public directory"
  task :setup, :roles => :app do
    run "if [ -d #{public_html} ]; then if [ ! -L #{public_html} ]; then rm -rf #{public_html} && echo #{public_html} deleted; fi; fi;"
    run "if [ ! -L #{public_html} ]; then ln -s #{current_path}/public #{public_html} && echo Symlink created for #{public_html}; fi"
  end

  desc "Check your site5 setup"
  task :check, :roles => :app do
    run "test -d #{public_html} && test -L #{public_html}"
  end
end