application = 'itechservice'
set :application, application
set :repo_url, 'git@bitbucket.org:itechdevs/itechservice.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

#set :deploy_to, "/usr/local/var/www/#{application}"
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, false

set :linked_files, %w{config/database.yml Procfile config/unicorn.rb config/private_pub.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets tmp/pdf vendor/bundle public/system public/uploads}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.2@itechservice'

set :sockets_path, shared_path.join('tmp/sockets')
set :pids_path, shared_path.join('tmp/pids')

namespace :server do

  desc 'Start server'
  task :start do
    on roles(:app) do
      if fetch(:stage) == :staging
        sudo "start #{fetch(:application)}"
      else
        sudo "launchctl load /Library/LaunchDaemons/#{fetch(:application)}-*"
      end
    end
  end

  desc 'Stop server'
  task :stop do
    on roles(:app) do
      if fetch(:stage) == :staging
        sudo "stop #{fetch(:application)}"
      else
        sudo "launchctl unload /Library/LaunchDaemons/#{fetch(:application)}-*"
      end
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:app) do
      if fetch(:stage) == :staging
        sudo "restart #{fetch(:application)}"
      else
        sudo "launchctl unload /Library/LaunchDaemons/#{fetch(:application)}-*"
        sudo "launchctl load /Library/LaunchDaemons/#{fetch(:application)}-*"
      end
    end
  end

  desc 'Server status'
  task :status do
    on roles(:app) do
      if fetch(:stage) == :staging
        execute "initctl list | grep #{fetch(:application)}"
      else
        sudo "launchctl list | grep #{fetch(:application)}"
      end
    end
  end

end

namespace :deploy do

  desc 'Setup'
  task :setup do
    on roles(:all) do
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/system"
      execute "mkdir -p #{shared_path}/tmp/pdf"
      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/unicorn.rb', "#{shared_path}/config/unicorn.rb")
      upload!('shared/private_pub.yml', "#{shared_path}/config/private_pub.yml")
      upload!('shared/application.yml', "#{shared_path}/config/application.yml")
      upload!('shared/Procfile', "#{shared_path}/Procfile")
      upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      execute 'mkdir -p /usr/local/etc/nginx/sites-available'
      execute 'mkdir -p /usr/local/etc/nginx/sites-enabled'
      execute "ln -sf #{shared_path}/nginx.conf /usr/local/etc/nginx/sites-enabled/#{application}.conf"
      # sudo 'nginx -s reload'
      # within release_path do
      #   with rails_env: fetch(:rails_env) do
      #     execute :rake, 'db:create'
      #   end
      # end
    end
  end

  desc 'Foreman init'
  task :foreman_init do
    on roles(:all) do
      foreman_temp = "/var/www/tmp/foreman"
      if fetch(:stage) == :staging
        execute "mkdir -p #{foreman_temp}"
        execute "ln -s #{release_path} #{current_path}"
        within current_path do
          execute "cd #{current_path}"
          execute :bundle, "exec foreman export upstart #{foreman_temp} -a #{application} -u deployer -l #{shared_path}/log -d #{current_path}"
        end
        sudo "mv #{foreman_temp}/* /etc/init/"
        sudo "rm -r #{foreman_temp}"
      else
        execute "mkdir -p #{foreman_temp}"
        execute "ln -s #{release_path} #{current_path}"
        within current_path do
          execute "cd #{current_path}"
          execute :bundle, "exec foreman export launchd #{foreman_temp} -a #{fetch(:application)} -u itech -l #{shared_path}/log -d #{current_path}"
        end
        sudo "mv #{foreman_temp}/* /Library/LaunchDaemons/"
        sudo "rm -r #{foreman_temp}"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # invoke 'server:restart'
    end
  end

  #after :finishing, 'deploy:cleanup'
  # after :finishing, 'server:restart'

  #after :setup, 'deploy:foreman_init'

  #after :foreman_init, 'server:start'

  #before :foreman_init, 'rvm:hook'

  before :migrate, 'deploy:set_rails_env'
  #before :setup, 'deploy:starting'
  #before :setup, 'deploy:updating'
  #before :setup, 'bundler:install'

end

#before 'deploy:updated', 'deploy:setup_config'
#after 'deploy:started', 'deploy:setup_config'
#after 'deploy:updated', 'deploy:symlink_config'
#before 'deploy', 'deploy:check_revision'

namespace :logs do
  desc 'Watch server logs'
  task :watch do
    on roles(:app) do
      if fetch(:stage) == :staging
        execute "tail -f #{current_path}/log/staging.log"
      else
        execute "tail -f #{current_path}/log/production.log"
      end
    end
  end
end

namespace :unicorn do

  desc 'Start unicorn server'
  task :start do
    on roles(:app) do
      execute "#{current_path}/bin/unicorn_init.sh start"
    end
  end

  desc 'Stop unicorn server'
  task :stop do
    on roles(:app) do
      execute "#{current_path}/bin/unicorn_init.sh stop"
    end
  end

  desc 'Restart unicorn server'
  task :restart do
    on roles(:app) do
      execute "#{current_path}/bin/unicorn_init.sh restart"
    end
  end

  desc 'Check unicorn server status'
  task :status do
    on roles(:app) do
      execute "#{current_path}/bin/unicorn_init.sh status"
    end
  end

end

namespace :delayed_job do

  desc 'Start delayed_job'
  task :start do
    on roles(:app) do
      execute "#{current_path}/bin/delayed_job_init.sh start"
    end
  end

  desc 'Stop delayed_job'
  task :stop do
    on roles(:app) do
      execute "#{current_path}/bin/delayed_job_init.sh stop"
    end
  end

  desc 'Restart delayed_job'
  task :restart do
    on roles(:app) do
      execute "#{current_path}/bin/delayed_job_init.sh restart"
    end
  end

  desc 'Check delayed_job status'
  task :status do
    on roles(:app) do
      execute "#{current_path}/bin/delayed_job_init.sh status"
    end
  end

end

namespace :private_pub do

  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      execute "#{current_path}/bin/private_pub_init.sh start"
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      execute "#{current_path}/bin/private_pub_init.sh stop"
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      execute "#{current_path}/bin/private_pub_init.sh restart"
    end
  end

  desc 'Check private_pub server status'
  task :status do
    on roles(:app) do
      execute "#{current_path}/bin/private_pub_init.sh status"
    end
  end

end