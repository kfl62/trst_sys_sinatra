# encoding: utf-8
module Trst
  module Sinatra
    module Helpers
      def hash_to_query_string(hash)
        hash.collect {|k,v| "#{k}=#{v}"}.join('&')
      end

      def login_required
        if current_user
          return true
        else
          flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.login_required'), :class => "error"}}.to_json
          redirect "#{lang_path}/"
          return false
        end
      end

      def current_user
        if session[:user]
          TrstUser.find(session[:user])
        else
          return false
        end
      end

      def logged_in?
        !!session[:user]
      end

      def lang_path
        lang = I18n.locale.to_s
        lang == "ro" ? "" : "/#{lang}"
      end

    end
  end
end

