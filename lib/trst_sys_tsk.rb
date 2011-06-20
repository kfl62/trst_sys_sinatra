# encoding: utf-8
=begin
#Handling tasks#
=end

class TrstSysTsk < Sinatra::Base
  # route for /srv/tsk/
  # @action Action: require login unless authorized user, set `session[:daily_tasks]`
  # @action Render: `/trst_sys/daily_tasks`
  get '/' do
    login_required
    session[:daily_tasks] = true
    haml :'/trst_sys/daily_tasks', :locals => {:tsks  => session[:tasks]}
  end

  # route for help, handler for displaying {TrstTask} help field
  # @see TrstTask TrstTask model => help field
  # @param [BSON::ObjectID.to_s] id the id of `@task`
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  get '/:id/help' do |id|
    @task = TrstTask.find(id)
    markdown @task.help
  end

  # route for filter
  # @param [BSON::ObjectID.to_s] id the id of `@task`
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  get '/:id/filter' do |id|
    @task, @object, haml_path, locals = init_variables(id, 'filter', nil, params)
    haml :"#{haml_path}", :layout => false, :locals => locals
  end

  # route for pdf params setting
  # @param [BSON::ObjectID.to_s] id the id of `@task`
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  get '/:id/pdf/' do |id|
    @task, @object, haml_path, locals = init_variables(id, 'pdf', nil, params)
    haml :"#{haml_path}", :layout => false, :locals => locals
  end

  # route for get (control center)
  # @param [BSON::ObjectID.to_s] id the id of `@task`
  # @param [String] verb any of `get, post, put, delete, filter`
  # @param [BSON::ObjectID.to_s] target_id the id of `@object`
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  get '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    unless verb == 'print'
      haml :"#{haml_path}", :layout => false, :locals => locals
    else
      headers({'Content-Type' => 'application/pdf',
               'Content-Description' => 'File Transfer',
               'Content-Transfer-Encoding' => 'binary',
               'Content-Disposition' => "attachment;filename=\"#{@object.file_name}.pdf\"",
               'Expires' => '0',
               'Pragma' => 'public'})
      ruby :"trst_pdf/#{@object.file_name}", :layout => false, :locals => locals
    end
  end

  # route for post(create)
  # @param (see #GET____id__verb__target_id_)
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  post '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    @object = @object.create
    flash[:msg] = {:msg => {:txt => I18n.t('db.post', :data => @object.name), :class => "info"}}.to_json
    haml :"#{haml_path}", :layout => false, :locals => locals
  end

  # route for put (update)
  # @param (see #GET____id__verb__target_id_)
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  put '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    if params[:target]
      update_hash = params[:"#{@object._parent.class.name.underscore}"]
    else
      update_hash = params_handle_ids(params,@object.class.name)
    end
    @object.update_attributes update_hash
    unless verb == 'print'
      flash[:msg] = {:msg => {:txt => I18n.t('db.put', :data => @object.name), :class => "info"}}.to_json
      haml :"#{haml_path}", :layout => false, :locals => locals
    else
      nil
    end
  end

  # route for delete
  # @param (see #GET____id__verb__target_id_)
  # @action Action: execute `@object.delete`
  # @action Render: nothing
   delete '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    @object.delete
    flash[:msg] = {:msg => {:txt => I18n.t('db.delete', :data => @object.name), :class => "info"}}.to_json
  end

  # add/delete relations
  # @param [BSON::ObjectID.to_s] id the id of `@task`
  # @param [String] verb any of `get, post, put, delete, filter`
  # @param [BSON::ObjectID.to_s] target_id the id of `@object`
  # @param [String] field
  # @param [String] action any of `add, delete`
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  get '/:id/:verb/:target_id/:field/:action' do |id,verb,target_id,field,action|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    @task = task
    @object = model.constantize.send method, target_id
    haml :"trst_sys/shared/relations", :layout  => false, :locals => {:action => action, :field => field}
  end

end
