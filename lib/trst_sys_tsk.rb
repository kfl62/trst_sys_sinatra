class TrstSysTsk < Sinatra::Base

  get '/' do
    login_required
    session[:daily_tasks] = true
    haml :'/trst_sys/daily_tasks', :locals => {:tsks  => session[:tasks]}
  end

  get '/:verb/:id' do |verb,id|
    task = TrstTask.find(id)
    model, method = task.target.split('.')
    haml_path = task.haml_path == 'default' ? '/trst_sys/shared' : task.haml_path
    @task = task
    @object = model.constantize.send method, id
    case verb
    when /get|delete/
      haml :"#{haml_path}/get_delete", :layout => false, :locals => {:action => verb}
    when /post|put/
      haml :"#{haml_path}/post_put", :layout => false, :locals => {:action => verb}
    when /help/
      haml "#{@task.help}"
    else
      haml "%p Wrong verb #{params.inspect}"
    end
  end

end
