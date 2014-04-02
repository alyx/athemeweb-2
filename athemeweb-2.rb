#!/usr/bin/env ruby

require 'sinatra/base'
require 'haml'
require 'yaml'

class AthemeWeb < Sinatra::Base

  @@config = YAML.load_file("athemeweb.conf")
  
  enable :sessions
  set :bind => @@config['app']['host'], :port => @@config['app']['port'], :session_secret => @@config['app']['secret']

  get '/' do
    haml :placeholder, :format => :html5
  end

end

AthemeWeb.run!
