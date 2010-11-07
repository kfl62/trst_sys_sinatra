# encoding: utf-8
=begin
#Sinatra helpers
Just for convenience (namespace)
=end
module Trst
  # #Sinatra helpers
  # Just for convenience (namespace)
  module Sinatra
    # #Sinatra helpers
    # Helper methods used in TrstSys, TrstSysTsk classes
    module Helpers
      # @return [String] return `Hash` key,value pairs as a `String`
      def hash_to_query_string(hash)
        hash.collect {|k,v| "#{k}=#{v}"}.join('&')
      end
      # @return [Boolean] true if `current_user`, else set `flash[:msg]` to error
      #   and redirect to public pages
      # @see #current_user
      def login_required
        if current_user
          return true
        else
          flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.login_required'), :class => "error"}}.to_json
          redirect "#{lang_path}/"
          return false
        end
      end
      # @return [TrstUser] if `session[:user]` exists, else return `false`
      # @see #login_required
      def current_user
        if session[:user]
          TrstUser.find(session[:user])
        else
          return false
        end
      end
      # @return [Boolean] check if `session[:user]` is initialized
      def logged_in?
        !!session[:user]
      end
      # Set language prefix for browser's path
      # @return [String]
      def lang_path
        lang = I18n.locale.to_s
        lang == "ro" ? "" : "/#{lang}"
      end
      # Store relations
      def params_handle_ids(p,m)
        retval = {}
        p[m.underscore.to_sym].each_pair do |key,value|
          retval[key] = key.index(/_ids/).nil? ?  CGI.unescape(value) : array_of_bson_ids(value)
        end
        retval
      end
      # Collect values as BSON::ObjectId's from an csv
      def array_of_bson_ids(value)
        if value.is_a?(Hash)
          hash = value
          retval = {}
          hash.each_pair do |key,value|
            retval[key] = value.split(',').collect{|id| BSON::ObjectId(id)}
          end
        else
          retval = value.split(',').collect{|id| BSON::ObjectId(id)}
        end
        retval
      end
      # Helper for initializing variables in TrstSysTsk handlers
      def init_variables(task_id,verb, target_id = nil,params = {})
        task = init_task(task_id)
        object = init_object(verb,task,target_id,params)
        haml_path = init_haml_path(verb,task)
        params = init_params(verb,task,params)
        return [task, object, haml_path, params]
      end
      # Initialize value for @task variable, get current task
      def init_task(task_id)
        task = TrstTask.find(task_id)
      end
      # Initialize value for @object variable, in current context
      def init_object(verb,task,target_id,params)
        model, method = task.target.split('.')
        model = model.constantize
        object = model
        if verb == 'filter'
          object = model.all.empty? ? model : model.all
          unless method == 'find'
            step = params[:step] || 'one'
            unless step == 'one'
              parent = model.find(params[:child_id])
              method = parent.associations.keys.first
              object = parent.send method
            end
          end
        elsif verb == 'pdf'
          object = model.send method, task.id
        else
          object = model.send method, target_id unless target_id == 'new'
        end
        return object
      end
      # Initialize load path for haml templates
      def init_haml_path(verb,task)
        model, method = task.target.split('.')
        haml_path = task.haml_path
        haml_path = (haml_path == 'default') ? '/trst_sys/shared' : haml_path
        case verb
        when /filter/
          haml_path += "/filter"
          haml_path += "_embedded" unless method == 'find'
        when /get|delete/
          haml_path += "/get_delete"
        when /post|put/
          haml_path += request.put? ? "/get_delete" : "/post_put"
        when /pdf/
          haml_path += "/pdf_params"
        else
          haml_path = "/trst_sys/error"
        end
        return haml_path
      end
      # Set values for :locals hash
      def init_params(verb,task,params)
        model, method = task.target.split('.')
        params[:action] = verb
        params[:action] = 'put' if request.post?
        params[:action] = 'get' if request.put?
        unless method == 'find'
         params[:step] = params[:step] ?  "two" : "one"
        end
        return params
      end

    end
  end
end

