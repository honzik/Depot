set :default_environment, {
  'PATH' => "/home/honzik/.rvm/gems/ruby-1.9.2-p180/bin:/home/honzik/.rvm/gems/ruby-1.9.2-p180@global/bin:/home/honzik/.rvm/rubies/ruby-1.9.2-p180/bin:/home/honzik/.rvm/bin:/home/honzik/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
  'RUBY_VERSION' => 'ruby 1.9.2p180',
  'GEM_HOME'     => '/home/honzik/.rvm/gems/ruby-1.9.2-p180',
  'GEM_PATH'     => '/home/honzik/.rvm/gems/ruby-1.9.2-p180:/home/honzik/.rvm/gems/ruby-1.9.2-p180@global',
  #'BUNDLE_PATH'  => '/path/to/.rvm/gems/ree-1.8.7-2010.01'  # If you are using bundler.
}

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:honzik/Depot.git"  # Your clone URL
set :scm, "git"
set :user, "honzik"  # The server's user for deploys
set :scm_passphrase, "fBOFZ8nVkL"  # The deploy user's password
ssh_options[:forward_agent] = true  # pouzije muj lokalni privatni klic
set :branch, "master"  # nastavi vychozi vetev
set :deploy_via, :remote_cache  # neudela kompetni clone pokazde

set :application, "Depot" #nazev aplikace
set :domain,  "remote.depot" # domena

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/honzik/rails_apps/#{domain}"

# z knihy ADWR
namespace :deploy do
  desc "cause passenger to init a restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "populate database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end
end

# z knihy ADWR
after "deploy:update_code", :bundle_install
desc "install bundle necessities"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end
  
  

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:


# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
