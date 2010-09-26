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

      def init_variables(task_id,verb, target_id = nil,params = {})
        task = init_task(task_id)
        object = init_object(verb,task,target_id,params)
        haml_path = init_haml_path(verb,task)
        params = init_params(verb,task,params)
        return [task, object, haml_path, params]
      end

      def init_task(task_id)
        task = TrstTask.find(task_id)
      end
      
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
        else
          object = model.send method, target_id unless target_id == 'new'
        end
        return object
      end

      def init_haml_path(verb,task)
        model, method = task.target.split('.')
        haml_path = task.haml_path
        haml_path = (haml_path == 'default') ? '/trst_sys/shared' : haml_path
        case verb
        when /filter/
          haml_path += "/#{verb}"
          haml_path += "_embedded" unless method == 'find'
        when /get|delete/
          haml_path += "/get_delete"
        when /post|put/
          haml_path += request.put? ? "/get_delete" : "/post_put"
        else
          haml_path = "/trst_sys/error"
        end
        return haml_path
      end

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

