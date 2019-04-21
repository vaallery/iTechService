# set :filter, hosts: %w[192.168.0.1 192.168.4.200]
# set :filter, hosts: %w[192.168.4.200]
ruby_v = '2.3.1'
user = fetch :user
# set :application, 'itechservice2'
set :application, 'itechservice'
set :repo_url, 'git@gitlab.com:k4ir05/iTechService.git'
set :branch, 'master'
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

#set :deploy_to, "/usr/local/var/www/#{fetch(:application)}"

# set :format, :pretty
set :log_level, :info
set :pty, false

set :conditionally_migrate, true

set :linked_files, %w{.env config/database.yml config/private_pub.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets tmp/pdf public/system public/uploads}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :conditionally_migrate, true

# set :rbenv_type, :user
# set :rbenv_ruby, ruby_v

set :rvm_type, :user
# set :rvm_ruby_version, "#{ruby_v}@#{fetch(:application)}"
set :rvm_ruby_version, ruby_v

set :bundle_flags, '--deployment'
set :bundle_env_variables, {
    path: "/Users/#{user}/.rvm/gems/#{fetch(:rvm_ruby_version)}/bin:/Users/#{user}/.rvm/gems/ruby-#{ruby_v}@global/bin:/Users/#{user}/.rvm/rubies/ruby-#{ruby_v}/bin:/Users/#{user}/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/Cellar/imagemagick/6.8.9-7/bin",
    magick_home: '/usr/local/Cellar/imagemagick/6.8.9-7',
    pkg_config_path: '/usr/local/bin'
}

set :sockets_path, shared_path.join('tmp/sockets')
set :pids_path, shared_path.join('tmp/pids')

set :passenger_rvm_ruby_version, ruby_v
set :passenger_restart_with_touch, true
# set :passenger_restart_command, 'passenger-config restart-app'
# set :passenger_restart_options, -> { "#{current_path} --ignore-app-not-running" }

set :whenever_identifier, fetch(:application)

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
      execute 'mkdir /var/www/log'
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/system"
      execute "mkdir -p #{shared_path}/bin"
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
      execute "ln -sf #{shared_path}/nginx_app.conf /usr/local/etc/nginx/sites-enabled/#{fetch(:application)}.conf"
      # sudo 'nginx -s reload'
      upload! 'shared/itechservice-web-1.plist', "#{shared_path}/itechservice-web-1.plist"
      upload! 'shared/itechservice-job-1.plist', "#{shared_path}/itechservice-job-1.plist"
      upload! 'shared/itechservice-pb-1.plist', "#{shared_path}/itechservice-pb-1.plist"
      # sudo "cp #{shared_path}/itechservice*.plist /Library/LaunchDaemons"
      # execute "rvm install #{fetch(:rvm_ruby_version)[/.*@/]}"
      # execute "rvm alias create ise #{fetch(:rvm_ruby_version)}"
      # within release_path do
      #   with rails_env: fetch(:rails_env) do
      #     execute :rake, 'db:schema:load'
      #   end
      # end
    end
  end

  desc 'Foreman init'
  task :foreman_init do
    on roles(:all) do
      foreman_temp = '/var/www/tmp/foreman'
      if fetch(:stage) == :staging
        execute "mkdir -p #{foreman_temp}"
        execute "ln -s #{release_path} #{current_path}"
        within current_path do
          execute "cd #{current_path}"
          execute :bundle, "exec foreman export upstart #{foreman_temp} -a #{fetch(:application)} -u deployer -l #{shared_path}/log -d #{current_path}"
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
      execute "touch #{current_path}/tmp/restart.txt"
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
  # after :published, 'sidekiq:start'
  # TODO after :published, 'sidekiq:restart'
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

  desc 'Upgrade unicorn server'
  task :upgrade do
    on roles(:app) do
      execute "#{current_path}/bin/unicorn_init.sh upgrade"
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