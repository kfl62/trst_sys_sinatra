# encoding: utf-8
module Trst
  module Sinatra
    module Helpers
      def hash_to_query_string(hash)
        hash.collect {|k,v| "#{k}=#{v}"}.join('&')
      end

      def login_required
        if current_user.class != GuestUser
          return true
        else
          session[:return_to] = request.fullpath
          redirect '/auth/login'
          return false
        end
      end

      def current_user
        if session[:user]
          TrstUser.get(:id => session[:user])
        else
          GuestUser.new
        end
      end

      def logged_in?
        !!session[:user]
      end
   
    end
  end
end

class GuestUser
  def guest?
    true
  end

  def permission_lvl
    10
  end

  def permission_grp
    ["public","guest"]
  end
  def method_missing(m, *args)
    return false
  end
end
