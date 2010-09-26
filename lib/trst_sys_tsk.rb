# encoding: utf-8
class TrstSysTsk < Sinatra::Base
  # route for / {{{1
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
    @task, @object, haml_path, locals = init_variables(id, 'filter', nil, params)
    haml :"#{haml_path}", :layout => false, :locals => locals
  end
  # route for get (control center) {{{1
  get '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    haml :"#{haml_path}", :layout => false, :locals => locals
  end
  # route for post(create) {{{1
  post '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    @object = @object.create
    flash[:msg] = {:msg => {:txt => I18n.t('db.post', :data => @object.name), :class => "info"}}.to_json
    haml :"#{haml_path}", :layout => false, :locals => locals
  end
  # route for put (update) {{{1
  put '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    update_hash = params_handle_ids(params,@object.class.name)
    @object.update_attributes update_hash
    flash[:msg] = {:msg => {:txt => I18n.t('db.put', :data => @object.name), :class => "info"}}.to_json
    haml :"#{haml_path}", :layout => false, :locals => locals
  end
  # route for delete {{{1
  delete '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    @object.delete
    flash[:msg] = {:msg => {:txt => I18n.t('db.delete', :data => @object.name), :class => "info"}}.to_json
  end
  # add/delete relations {{{1
  get '/:id/:verb/:target_id/:field/:action' do |id,verb,target_id,field,action|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    @task = task
    @object = model.constantize.send method, target_id
    haml :"trst_sys/shared/relations", :layout  => false, :locals => {:action => action, :field => field}
  end #}}}
end
