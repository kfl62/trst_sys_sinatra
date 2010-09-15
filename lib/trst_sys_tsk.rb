class TrstSysTsk < Sinatra::Base

  get '/' do
    login_required
    session[:daily_tasks] = true
    haml :'/trst_sys/daily_tasks', :locals => {:tsks  => session[:tasks]}
  end
  # route for help {{{1
  get '/:id/help' do |id|
    @task = TrstTask.find(id)
    haml ":markdown\n  #{@task.help}"
  end
  # route for filter {{{1
  get '/:id/filter' do |id|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    haml_path = task.haml_path == 'default' ? '/trst_sys/shared' : task.haml_path
    @task = task
    @object = model.constantize.all
    if @object.empty?
      @object = model.constantize
      haml :"#{haml_path}/post_put", :layout => false, :locals => {:action => 'post'}
    else
      haml :"#{haml_path}/filter", :layout => false, :locals => {:action => 'filter'}
    end
  end
  # route for get (control center) {{{1
  get '/:id/:verb/:target_id' do |id,verb,target_id|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    haml_path = task.haml_path == 'default' ? '/trst_sys/shared' : task.haml_path
    @task = task
    if target_id == 'new'
      @object =  model.constantize 
    else 
      @object = model.constantize.send method, target_id
    end
    case verb
    when /get|delete/
      haml :"#{haml_path}/get_delete", :layout => false, :locals => {:action => verb}
    when /post|put/
      haml :"#{haml_path}/post_put", :layout => false, :locals => {:action => verb}
    else
      haml "%p Wrong verb #{params.inspect}"
    end
  end
  # route for post(create) {{{1
  post '/:id/:verb/:target_id' do |id,verb,target_id|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    haml_path = task.haml_path == 'default' ? '/trst_sys/shared' : task.haml_path
    case method
    when 'find'
      @task = task
      @object = model.constantize.create
    else
      params.inspect
    end
    flash[:msg] = {:msg => {:txt => I18n.t('db.post', :data => model), :class => "info"}}.to_json
    haml :"#{haml_path}/post_put", :layout => false, :locals => {:action => 'put'}
  end
  # route for put (update) {{{1
  put '/:id/:verb/:target_id' do |id,verb,target_id|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    haml_path = task.haml_path == 'default' ? '/trst_sys/shared' : task.haml_path
    case method
    when 'find'
      @task = task
      @object = model.constantize.send method, target_id
      @object.update_attributes params[model.underscore.to_sym]
    else
      params.inspect
    end
    flash[:msg] = {:msg => {:txt => I18n.t('db.put', :data => model), :class => "info"}}.to_json
    haml :"#{haml_path}/get_delete", :layout => false, :locals => {:action => 'get'}
  end
  # route for delete {{{1
  delete '/:id/:verb/:target_id' do |id,verb,target_id|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    case method
    when 'find'
      @task = task
      @object = model.constantize.send method, target_id
      @object.delete
    else
      params.inspect
    end
    flash[:msg] = {:msg => {:txt => I18n.t('db.delete', :data => @object.name), :class => "info"}}.to_json
  end

end
