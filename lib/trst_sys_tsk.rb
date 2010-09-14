class TrstSysTsk < Sinatra::Base

  get '/' do
    login_required
    session[:daily_tasks] = true
    haml :'/trst_sys/daily_tasks', :locals => {:tsks  => session[:tasks]}
  end

  get '/:id/help' do |id|
    @task = TrstTask.find(id)
    haml ":markdown\n  #{@task.help}"
  end

  get '/:id/filter' do |id|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    haml_path = task.haml_path == 'default' ? '/trst_sys/shared' : task.haml_path
    @task = task
    @object = model.constantize.all
    if @object.empty?
      haml :"#{haml_path}/post_put", :layout => false, :locals => {:action => 'post'}
    else
      haml :"#{haml_path}/filter", :layout => false, :locals => {:action => 'filter'}
    end
  end

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

end
