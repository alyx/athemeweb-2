require 'rubygems'
require 'bundler'
require 'yaml'
require 'xmlrpc/client'
require 'rack-flash'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'app/routes/main'
require 'app/routes/user'

module AthemeWeb
  class App < Sinatra::Application
    @@config = YAML.load_file('athemeweb.conf')
    @@xmlrpc = XMLRPC::Client.new(@@config['atheme']['host'], '/xmlrpc', @@config['atheme']['port'])
    configure do
      disable :method_override
      disable :static
      set :bind, @@config['app']['host']
      set :port, @@config['app']['port']
      set :server, :thin
      set :sessions,
        :secret => @@config['app']['secret']
    end
    use Rack::Deflater
    use Rack::Session::Cookie, :secret => @@config['app']['secret']
    use Rack::Session::Pool, :expire_after => 31557600
    use Rack::Flash
    use Routes::Main
    use Routes::User
    def self.config(sec, item)
      @@config[sec][item]
    end
    def self.xmlrpc_get(method, *args)
      @@xmlrpc.call2(method, *args)
    end
    def self.log(data)
      @@logger.debug data
    end
  end
end
