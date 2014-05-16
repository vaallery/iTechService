module ActiveRecord::ConnectionSwitch
  def on_connection(options)
    raise ArgumentError, 'Got nil object instead of db config options' if options.nil?
    ActiveRecord::Base.establish_connection options
    yield
  ensure
    ActiveRecord::Base.establish_connection ActiveRecord::Base.configurations[Rails.env]
  end
end

ActiveRecord.send :extend, ActiveRecord::ConnectionSwitch