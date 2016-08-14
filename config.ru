# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

if Rails.env.development?

  Thread.new do
    system 'rackup private_pub.ru -s thin -E production'
  end

  # require "bundler/setup"
  # require "yaml"
  # require "faye"
  # require "private_pub"
  #
  # Faye::WebSocket.load_adapter('thin')
  #
  # PrivatePub.load_config(File.expand_path("../config/private_pub.yml", __FILE__), ENV["RAILS_ENV"] || "development")
  # run PrivatePub.faye_app

#   require 'eventmachine'
#   require 'rack'
#   require 'thin'
#   require 'faye'
#
#   Faye.logger = Logger.new(Rails.root.join('log/faye.log'))
#
#   Faye::WebSocket.load_adapter('thin')
#
#   thread = Thread.new do
#     EM.run {
#       thin = Rack::Handler.get('thin')
#       app = Faye::RackAdapter.new(mount: '/faye', timeout: 10)
#       thin.run(app, :Port => 8000) do |server|
#         ## Set SSL if needed:
#         # server.ssl_options = {
#         #   :private_key_file => 'path/to/ssl.key',
#         #   :cert_chain_file  => 'path/to/ssl.crt'
#         # }
#         # server.ssl = true
#       end
#     }
#   end
#   at_exit { thread.exit }
end