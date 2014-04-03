require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'app/routes/main'

module AthemeWeb
  class App < Sinatra::Application
    @@config = YAML.load_file('athemeweb.conf')
    configure do
      register Sinatra::Async
      disable :method_override
      disable :static
      set :bind, @@config['app']['host']
      set :port, @@config['app']['port']
      set :server, :thin
      set :sessions,
        :httponly     => true,
        :secure       => production?,
        :expire_after => 31557600,
        :secret       => @@config['app']['secret']
    end
    use Rack::Deflater
    use Routes::Main
  end
end
