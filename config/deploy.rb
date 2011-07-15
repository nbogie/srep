require "rubygems"

set :stages, %w(staging production)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'
set :bundle_without, [:development, :test, :deployer]

# Add RVM's lib directory to the load path
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require 'rvm/capistrano'
set :rvm_gemset,                 'reportapp'
set :rvm_ruby_string_no_gemset,  'ruby-1.8.7-p249'
#rvm_type and rvm_ruby_string and needed by rvm/cap integration
#see: https://rvm.beginrescueend.com/integration/capistrano/
set :rvm_ruby_string,            rvm_ruby_string_no_gemset + '@' + rvm_gemset
set :rvm_type, :user

# Automagically runs bundle:install as part of our deploy
require "bundler/capistrano"

set :application, "reportapp"
set :repository,  "git://github.com/nbogie/srep.git"
set :scm, :git

# only keep 5 releases
set :keep_releases, 5

# Capistrano deploy options to handle forwarding ssh keys properly
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# define the user we will be connecting to our machines as
set :user, "rails"

# run admin commands as the rails user, so that permissions are correct
set :admin_runner, "rails"

# Task dependencies
after  "deploy:setup",          "deploy:create_shared_config_dir",
                                "deploy:create_configs", 
                                "deploy:create_pids_dir"

after  "deploy:update_code",    "deploy:symlink_configs"

namespace :deploy do

  #======= Some convenience methods ===========================================
  def copy_sample_to_config(file)
    put File.read("config/#{file}.sample"), "#{shared_path}/config/#{file}"
  end
  
  #remake a symlink from release_path/config/file to /shared_path/config/file
  def remake_config_symlink(file)
    remake_symlink(file, "#{shared_path}/config")
  end

  def remake_symlink(file, src_dir)
    #we want to fail if the linked-to yml isn't there
    #so instead of forcing the ln, we first remove any pre-existing link
    run "rm -f #{release_path}/config/#{file}"
    run "ln -ns #{src_dir}/#{file} #{release_path}/config/#{file}"
  end
  #======= end convenience methods ===========================================

  task :create_configs, :roles => [:app] do
    copy_sample_to_config("database.yml")
    copy_sample_to_config("source_database.yml")
  end

  desc "recreate all symlinks from current release's apparent configs to their permanent location in the shared config dir"
  task :symlink_configs, :roles => [:app] do
    remake_config_symlink("database.yml")
    remake_config_symlink("source_database.yml")
  end


  desc "Ensure shared config directory exists"
  task :create_shared_config_dir, :roles => [:app] do
    run "mkdir -p #{shared_path}/config/"
  end

  desc "Ensure pid directory exists for thins to write to"
  task :create_pids_dir, :roles => [:app] do
    run "mkdir -p #{shared_path}/pids/"
  end

end

  task :start do
    #run "/etc/init.d/reportapp start"
  end

  task :stop do
    run "/etc/init.d/reportapp stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/etc/init.d/reportapp restart"
  end
