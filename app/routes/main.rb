module AthemeWeb
  module Routes
    class Main < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)
        disable :method_override
        disable :protection
        enable :static
      end
      get '/' do
        haml :placeholder, :format => :html5
      end
    end
  end
end
