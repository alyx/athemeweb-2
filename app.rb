require 'rubygems'
require 'bundler'
require 'yaml'
require 'xmlrpc/client'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'app/routes/main'

module AthemeWeb
  class App < Sinatra::Application
    @@config = YAML.load_file('athemeweb.conf')
    @@xmlrpc = XMLRPC::Client.new(@@config['atheme']['host'], '/xmlrpc', @@config['atheme']['port'])
    log_file = File.open('athemeweb.log', 'a+')
    log_file.sync = true
    @@logger = Logger.new(log_file)
    @@logger.level = Logger::DEBUG
    configure do
      register Sinatra::Async
      disable :method_override
      disable :static
      set :bind, @@config['app']['host']
      set :port, @@config['app']['port']
      set :server, :thin
      set :logger, @@logger
      set :sessions,
        :httponly     => true,
        :secure       => production?,
        :expire_after => 31557600,
        :secret       => @@config['app']['secret']
    end
    use Rack::Deflater
    use Routes::Main
    def self.config(sec, item)
      @@config[sec][item]
    end
    def self.xmlrpc_get(method, *args)
      @@xmlrpc.call(method, *args)
    end
    def self.log(data)
      @@logger.debug data
    end
  end
end
