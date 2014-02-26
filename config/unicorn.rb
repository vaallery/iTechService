#root = '/Users/itech/sites/itech_service'
root = '/usr/local/var/www/itechservice/current'
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

#listen '/tmp/unicorn.itech_service.sock'
listen "#{root}/tmp/sockets/unicorn.sock"
worker_processes 4
timeout 30
