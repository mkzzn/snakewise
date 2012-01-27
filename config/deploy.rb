$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
require 'bundler/capistrano'

set :bundle_flags,      "--deployment --verbose"

set :application, "snakewise"
set :user, "mz"
set :port, 1440
set :use_sudo, true 

set :repository,  "mkzzn_github:mkzzn/snakewise.git"
set :deploy_to, "/var/www/#{application}"
set :scm, :git

default_run_options[:pty] = true

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
set :rvm_ruby_string, 'ruby-1.9.2-p290@global'   # Or whatever env you want it to run in.
set :rvm_type, :user

set :default_environment, {
  'PATH' => "/home/mz/.rvm/gems/ruby-1.9.2-p290@snakewise/bin:/home/mz/.rvm/rubies/ruby-1.9.2-p290/bin:/home/mz/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'    => "/var/www/snakewise/shared/bundle/ruby/1.9.1/gems:/home/mz/.rvm/gems/ruby-1.9.2-p290@snakewise",
  'GEM_PATH'    => "/var/www/snakewise/shared/bundle/ruby/1.9.1/gems:/home/mz/.rvm/gems/ruby-1.9.2-p290@snakewise:/home/mz/.rvm/gems/ruby-1.9.2-p290@snakewise",
  'BUNDLE_PATH'    => "/var/www/snakewise/shared/bundle/:/home/mz/.rvm/gems/ruby-1.9.2-p290@snakewise:/home/mz/.rvm/gems/ruby-1.9.2-p290@snakewise"
}

#set :port, 1440                      # The port you've setup in the SSH setup section
set :location, "97.107.142.52"
role :app, location
role :web, location
role :db,  location, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Make symlink for database.yml" 
  task :symlink_dbyaml do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end

  desc "Create empty database.yml in shared path" 
  task :create_dbyaml do
    run "mkdir -p #{shared_path}/config" 
    put '', "#{shared_path}/config/database.yml" 
  end
end

after 'deploy:setup', 'deploy:create_dbyaml'
after 'deploy:update_code', 'deploy:symlink_dbyaml'

after "deploy", "deploy:cleanup"
