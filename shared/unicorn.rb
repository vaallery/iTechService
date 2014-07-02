root = '/var/www/itechservice/current'
worker_processes 4
timeout 30
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.stderr.log"
stdout_path "#{root}/log/unicorn.stdout.log"

listen "#{root}/tmp/sockets/unicorn.sock", :backlog => 64
listen 3030, tcp_nopush: true

# preload_app true
# GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)
# check_client_connection true

# before_fork do |server, worker|
#   ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
#     old_pid = "#{server.config[:pid]}.oldbin"
#     if old_pid != server.pid
#       begin
#         sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
#         Process.kill(sig, File.read(old_pid).to_i)
#       rescue Errno::ENOENT, Errno::ESRCH
#       end
#     end
# end

# after_fork do |server, worker|
#   ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
# end