module AthemeWeb
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)

        disable :method_override
        disable :protection
        disable :static

        enable :use_code
      end

      helpers Helpers
      helpers Sinatra::ContentFor
    end
  end
end
