Bluepill.application('itechservice') do |app|
  process.uid = 'deployer'
  process.gid = 'deployer'
  app.process('unicorn') do |process|
    process.start_command = '/usr/local/bin/ise_unicorn'
    process.pid_file = '/var/www/itechservice/current/tmp/pids/unicorn.pid'

    # process.checks :cpu_usage, every: 10.seconds, below: 5, times: 3
    # process.checks :mem_usage, every: 10.seconds, below: 100.megabytes, times: [3, 5]
  end
end