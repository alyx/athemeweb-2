module AthemeWeb
  module AthemeHelper
    def has_priv(priv)
      return False if session[:authcookie].nil?
      success, privs = AthemeWeb::App.xmlrpc_get('atheme.privset', session[:authcookie], session[:user], '0.0.0.0')
      return privs.split(' ').include? priv
    end
  end
end
