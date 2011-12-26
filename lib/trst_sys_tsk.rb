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
    help_path = @task.help.split('_')
    if help_path.shift == "file"
      help_path = File.join('help',help_path)
      markdown :"#{help_path}"
    else
      markdown @task.help
    end
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

  # @todo Documentation
  get '/:id/unit_id/:unit_id' do |id,unit_id|
    session[:unit_id] = (unit_id == 'null') ? nil : unit_id
    verb = TrstTask.find(id).target.split('.')[1] == 'repair' ? 'repair' : 'filter'
    @task, @object, haml_path, locals = init_variables(id, verb, nil, params)
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

  # @todo Documentation
  get '/:id/query/' do |id|
    @task, @object, haml_path, locals = init_variables(id, 'query', nil, params)
    haml :"#{haml_path}", :layout => false, :locals => locals
  end

  # @todo Documentation
  get '/:id/repair/:date' do |id,date|
    session[:date] = (date == 'null' || date.nil?) ? Date.today.to_s : date
    @task, @object, haml_path, locals = init_variables(id, 'repair', nil, params)
    haml :"#{haml_path}", :layout => false, :locals => locals
  end

  # @todo Documentation
  get '/:id/test/' do |id|
    @task, @object, haml_path, locals = init_variables(id, 'test', nil, params)
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
    if verb == 'print'
      headers({'Content-Type' => 'application/pdf',
               'Content-Description' => 'File Transfer',
               'Content-Transfer-Encoding' => 'binary',
               'Content-Disposition' => "attachment;filename=\"#{@object.file_name}.pdf\"",
               'Expires' => '0',
               'Pragma' => 'public'})
      ruby :"#{haml_path}/#{@object.pdf_template rescue @object.file_name}", :layout => false, :locals => locals
    else
      haml :"#{haml_path}", :layout => false, :locals => locals
    end
  end

  # route for post(create)
  # @param (see #GET____id__verb__target_id_)
  # @action Action:
  # @action Render:
  # @todo Documentation for Action:,Render:
  post '/:id/:verb/:target_id' do |id,verb,target_id|
    @task, @object, haml_path, locals = init_variables(id, verb, target_id, params)
    if params[:target]
      @object = @object.where("#{params[:target]}._id" => BSON::ObjectId.from_string(params[:child_id])).first
      @object = @object.method(params[:target]).call.create
    elsif params[:id_pn]
      @object = @object.create(:client_id => BSON::ObjectId.from_string(params[:id_pn]), :unit_id => current_user.unit_id || session[:unit_id])
    elsif params[:client_id] && params[:transporter_id]
      @object = @object.create(:client_id => BSON::ObjectId.from_string(params[:client_id]), :transporter_id => BSON::ObjectId.from_string(params[:transporter_id]), :unit_id => current_user.unit_id || session[:unit_id])
    elsif params[:client_id] && params[:dns]
      @object = @object.create(:client_id => BSON::ObjectId.from_string(params[:client_id]))
      params[:dns].split(',').each do |dn|
        @object.delivery_notes << TrstAccDeliveryNote.find(dn)
        @object.save
      end
    elsif params[:supplier_id]
      unit_id = BSON::ObjectId.from_string(params[:to_unit]) if params[:to_unit]
      unit_id ||= current_user.unit_id || session[:unit_id]
      @object = @object.create(:supplier_id => BSON::ObjectId.from_string(params[:supplier_id]), :unit_id => unit_id)
      if params[:dns]
        params[:dns].split(',').each do |dn|
          @object.delivery_notes << TrstAccDeliveryNote.find(dn)
          @object.save
        end
      end
    else
      if @object.instance_methods.include?(:unit_id)
        @object = @object.create(:unit_id => current_user.unit_id || session[:unit_id])
      else
        @object = @object.create
      end
    end
    @object.update_attributes(:signed_by_id => current_user.id) if @object.class.instance_methods.include?(:signed_by_id)
    @object.reload
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
    if params[:freights]
      params[:freights].values.each do |v|
        o = @object.freights.find_or_create_by(:id => v["id"], :id_stats => v["id_stats"]) unless v["freight_id"].nil? || v["freight_id"].empty?
        o.update_attributes v unless o.nil?
      end
      @object.reload
    end
    if params[:inv_freights]
      params[:inv_freights].values.each do |v|
        o = @object.freights.find_or_create_by(:id_stats => v["id_stats"])
        o.update_attributes v unless o.nil?
      end
      @object.update_delivery_notes(true)
    end
    if params[:delegates]
      d = TrstPartner.find(@object.supplier_id).delegates.create(params[:delegates])
      @object.update_attribute(:delegate_id, d.id)
    end
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
    @object.destroy
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
