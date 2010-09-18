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
      
      def params_handle_ids(p,m)
        retval = {}
        p[m.underscore.to_sym].each_pair do |key,value|
          retval[key] = key.index(/_ids/).nil? ?  CGI.unescape(value) : array_of_bson_ids(value)
        end
        retval
      end

      def array_of_bson_ids(ids)
        retval = []
        ids.split(',').each do |id|
          retval << BSON::ObjectId(id)
        end
        retval
      end

    end
  end
end

