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
        if session[:authcookie].nil?
          body { haml :login, :format => :html5 }
        else
          body { haml :placeholder, :format => :html5 }
        end
      end
      get '/user/login' do
        body { haml :login, :format => :html5 }
      end
      post '/user/login' do
        success, cookie = AthemeWeb::App.xmlrpc_get('atheme.login', params[:username], params[:password], request.ip)
        if success
          session[:authcookie] = cookie
          body { cookie }
        else
          flash[:notice] = cookie.faultString
          body { haml :login, :format => :html5 }
        end
      end
      get '/user/logout' do
        session[:authcookie] = nil
        flash[:notice] = "You are now logged out."
        body { haml :login, :format => :html5 }
      end       
    end
  end
end
