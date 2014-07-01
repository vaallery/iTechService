set :filter, hosts: %w[192.168.0.1]
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
# set :rvm_ruby_version, 'ruby-2.0.0-p451@itechservice'
# set :rvm_ruby_version, 'ruby-2.0.0-p481@itechservice'
set :rvm_ruby_version, 'ruby-2.1.2@itechservice'

# set :bundle_flags, '--deployment'
# set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

set :sockets_path, shared_path.join('tmp/sockets')
set :pids_path, shared_path.join('tmp/pids')

namespace :server do

  desc 'Start server'
  task :start do
    on roles(:app) do
      if fetch(:stage) == :staging
        sudo "start #{application}"
      else
        sudo "launchctl load /Library/LaunchDaemons/#{application}-*"
      end
    end
  end

  desc 'Stop server'
  task :stop do
    on roles(:app) do
      if fetch(:stage) == :staging
        sudo "stop #{application}"
      else
        sudo "launchctl unload /Library/LaunchDaemons/#{application}-*"
      end
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:app) do
      if fetch(:stage) == :staging
        sudo "restart #{application}"
      else
        sudo "launchctl unload /Library/LaunchDaemons/#{application}-*"
        sudo "launchctl load /Library/LaunchDaemons/#{application}-*"
      end
    end
  end

  desc 'Server status'
  task :status do
    on roles(:app) do
      if fetch(:stage) == :staging
        execute "initctl list | grep #{application}"
      else
        sudo "launchctl list | grep #{application}"
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
      execute 'mkdir -p /usr/local/etc/nginx/sites-available'
      execute 'mkdir -p /usr/local/etc/nginx/sites-enabled'
      upload! 'shared/database.yml', "#{shared_path}/config/database.yml"
      upload! 'shared/unicorn.rb', "#{shared_path}/config/unicorn.rb"
      upload! 'shared/private_pub.yml', "#{shared_path}/config/private_pub.yml"
      upload! 'shared/application.yml', "#{shared_path}/config/application.yml"
      upload! 'shared/Procfile', "#{shared_path}/Procfile"
      upload! 'shared/unicorn_init.sh', "#{shared_path}/bin/unicorn_init.sh"
      execute "ln -sf #{shared_path}/bin/unicorn_init.sh /usr/local/bin/ise_unicorn"
      upload! 'shared/delayed_job_init.sh', "#{shared_path}/bin/delayed_job_init.sh"
      execute "ln -sf #{shared_path}/bin/delayed_job_init.sh /usr/local/bin/ise_delayed_job"
      upload! 'shared/private_pub_init.sh', "#{shared_path}/bin/private_pub_init.sh"
      execute "ln -sf #{shared_path}/bin/private_pub_init.sh /usr/local/bin/ise_private_pub"
      upload! 'shared/nginx.conf', '/usr/local/etc/nginx/nginx.conf'
      upload! 'shared/nginx_app.conf', "#{shared_path}/nginx_app.conf"
      execute "ln -sf #{shared_path}/nginx_app.conf /usr/local/etc/nginx/sites-enabled/#{application}.conf"
      # sudo 'nginx -s reload'
      upload! 'shared/itechservice*1.plist', shared_path
      sudo "cp #{shared_path}/itechservice*1.plist /Library/LaunchDaemons"
      # execute "rvm install #{fetch(:rvm_ruby_version)[/.*@/]}"
      execute "rvm alias create ise #{fetch(:rvm_ruby_version)}"
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
          execute :bundle, "exec foreman export launchd #{foreman_temp} -a #{application} -u itech -l #{shared_path}/log -d #{current_path}"
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
      # execute "#{current_path}/bin/unicorn_init.sh start"
      execute 'ise_unicorn start'
    end
  end

  desc 'Stop unicorn server'
  task :stop do
    on roles(:app) do
      # execute "#{current_path}/bin/unicorn_init.sh stop"
      execute 'ise_unicorn stop'
    end
  end

  desc 'Restart unicorn server'
  task :restart do
    on roles(:app) do
      # execute "#{current_path}/bin/unicorn_init.sh restart"
      execute 'ise_unicorn restart'
    end
  end

  desc 'Check unicorn server status'
  task :status do
    on roles(:app) do
      # execute "#{current_path}/bin/unicorn_init.sh status"
      execute 'ise_unicorn status'
    end
  end

end

namespace :delayed_job do

  desc 'Start delayed_job'
  task :start do
    on roles(:app) do
      # execute "#{current_path}/bin/delayed_job_init.sh start"
      execute 'ise_delayed_job start'
    end
  end

  desc 'Stop delayed_job'
  task :stop do
    on roles(:app) do
      # execute "#{current_path}/bin/delayed_job_init.sh stop"
      execute 'ise_delayed_job stop'
    end
  end

  desc 'Restart delayed_job'
  task :restart do
    on roles(:app) do
      # execute "#{current_path}/bin/delayed_job_init.sh restart"
      execute 'ise_delayed_job restart'
    end
  end

  desc 'Check delayed_job status'
  task :status do
    on roles(:app) do
      # execute "#{current_path}/bin/delayed_job_init.sh status"
      execute 'ise_delayed_job status'
    end
  end

end

namespace :private_pub do

  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      # execute "#{current_path}/bin/private_pub_init.sh start"
      execute 'ise_private_pub start'
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      # execute "#{current_path}/bin/private_pub_init.sh stop"
      execute 'ise_private_pub stop'
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      # execute "#{current_path}/bin/private_pub_init.sh restart"
      execute 'ise_private_pub restart'
    end
  end

  desc 'Check private_pub server status'
  task :status do
    on roles(:app) do
      # execute "#{current_path}/bin/private_pub_init.sh status"
      execute 'ise_private_pub status'
    end
  end

end