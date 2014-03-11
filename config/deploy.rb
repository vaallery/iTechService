set :filter, hosts: %w[192.168.4.200]
set :application, 'itechservice'
set :repo_url, 'git@bitbucket.org:itechdevs/itechservice.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

#set :deploy_to, "/usr/local/var/www/#{application}"
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml Procfile}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-1.9.3-p545@itechservice' #'2.0.0-p451'

set :sockets_path, shared_path.join('tmp/sockets')
set :pids_path, shared_path.join('tmp/pids')

namespace :foreman do
  desc 'Start server'
  task :start do
    on roles(:all) do
      sudo "start #{application}"
    end
  end

  desc 'Stop server'
  task :stop do
    on roles(:all) do
      sudo "stop #{application}"
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:all) do
      sudo "restart #{application}"
    end
  end

  desc 'Server status'
  task :status do
    on roles(:all) do
      execute "launchctl list | grep #{application}"
    end
  end
end

namespace :deploy do

  #desc 'Restart application'
  #task :restart do
  #  on roles(:app), in: :sequence, wait: 5 do
  #    # Your restart mechanism here, for example:
  #    execute :touch, release_path.join('tmp/restart.txt')
  #  end
  #end

  #after :restart, :clear_cache do
  #  on roles(:web), in: :groups, limit: 3, wait: 10 do
  #    # Here we can do anything such as:
  #    within release_path do
  #      execute :rake, 'cache:clear'
  #    end
  #  end
  #end

  desc 'Setup'
  task :setup do
    on roles(:all) do
      deploy_path = fetch :deploy_to
      #execute "mkdir #{shared_path}/config/"
      #execute "mkdir #{shared_path}/system"
      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/Procfile', "#{shared_path}/Procfile")
      #upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      #sudo 'start nginx'
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:create'
        end
      end
    end
  end

  #desc 'Create symlink'
  #task :symlink do
  #  on roles(:all) do
  #    execute "ln -fs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  #    execute "ln -fs #{shared_path}/Procfile #{release_path}/Procfile"
  #  end
  #end

  desc 'Foreman init'
  task :foreman_init do
    on roles(:all) do
      foreman_temp = "/usr/local/var/www/tmp/foreman"
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

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "restart #{application}"
    end
  end

  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'

  #after :updating, 'deploy:symlink'

  after :setup, 'deploy:foreman_init'

  after :foreman_init, 'foreman:start'

  before :foreman_init, 'rvm:hook'

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'

end

#before 'deploy:updated', 'deploy:setup_config'
#after 'deploy:started', 'deploy:setup_config'
#after 'deploy:updated', 'deploy:symlink_config'
#before 'deploy', 'deploy:check_revision'