# encoding: utf-8
module Trst
  # ##Description
  # ##Scope
  # @todo documentation
  class System < Sinatra::Base
    register Sinatra::Flash
    register Trst::Helpers
    set :views, File.join(Trst.views, 'system')

    if Trst.env == 'development'
      use Assets::Stylesheets
      use Assets::Javascripts
    end

    before do
      if session[:user]
        @current_user ||= User.find(session[:user])
        I18n.reload! if Trst.env == 'development'
      else
        flash[:msg] = {msg: {txt: t('login.required'), class: 'error'}}
        redirect  "#{lp}/"
      end
    end

    # @todo Document this route
    get '/' do
      book = Book.find_by(slug: 'trst_system')
      @chapters = book.chapters
      start_pg  = book.chapters.find_by(slug: 'my_page')
      @content  = page_content(start_pg.id.to_s)
      markdown @content, layout: true, :layout_engine => :haml
    end
    # @todo Document this route
    get '/tasks/:page_id' do |page|
      @page = Book.page(page)
      @tasks = (@page.task_ids & @current_user.task_ids).map{|id| Task.find(id)}
      haml :tasks, layout: false
    end
    # @todo Document this route
    get '/help/:task_id' do |id|
      @content = page_content(id,true)
      markdown @content
    end
    # @todo Document this route
    get '/:module/:class/filter' do |m,c|
      handle_params(m,c,nil,'filter',params)
      haml haml_path('filter',!@related_object.nil?), layout: false
    end
    # @todo Document this route
    get '/:module/:class/print' do |m,c|
      id    = params[:id].nil? ? nil : params[:id]
      action= params[:id].nil? ? 'filter' : 'print'
      handle_params(m,c,id,action,params)
      file = haml_path('pdf')
      if params['haml']
        haml file, layout: false
      else
        headers({'Content-Type' => 'application/pdf',
                 'Content-Description' => 'File Transfer',
                 'Content-Transfer-Encoding' => 'binary',
                 'Content-Disposition' => "attachment;filename=\"#{@object.file_name}.pdf\"",
                 'Expires' => '0',
                 'Pragma' => 'public'})
        pdf file, layout: false
      end
    end
    # @todo Document this route
    get '/:module/:class/create' do |m,c|
      handle_params(m,c,nil,'create_get',params)
      haml haml_path('create'), layout: false
    end
    # @todo Document this route
    post '/:module/:class/create' do |m,c|
      handle_params(m,c,nil,'create_post',params)
      if @object.save
        flash[:msg] = {msg: {txt: t('create.msg.end', data: mat(@object,'model_name')), class: 'info'}}
        haml haml_path('show'), layout: false
      else
        flash[:msg] = {msg: {txt: t('create.msg.error', data: mat(@object,'model_name')), class: 'error'}}
        @create_error = true
        haml haml_path('create'), layout: false
      end
    end
    # @todo Document this route
    get '/:module/:class/edit/:id' do |m,c,id|
      handle_params(m,c,id,'edit_get',params)
      haml haml_path('edit'), layout: false
    end
    # @todo Document this route
    get '/:module/:class/delete/:id' do |m,c,id|
      handle_params(m,c,id,'delete_get',params)
      haml haml_path('delete'), layout: false
    end
    # @todo Document this route
    get '/:module/:class/:id' do |m,c,id|
      handle_params(m,c,id,'show',params)
      haml haml_path('show'), layout: false
    end
    # @todo Document this route
    get '/:module/:class/:id/tab/:what/:verb' do |m,c,id,w,v|
      handle_params(m,c,id,v,params)
      haml :"#{m}/#{c}/_#{w}", layout: false
    end
    # @todo Document this route
    put '/:module/:class/:id' do |m,c,id|
      handle_params(m,c,id,'edit_put',params)
      if @object.update_attributes(params[:"#{@path}"])
        flash[:msg] = {msg: {txt: t('edit.msg.end', data: mat(@object,'model_name')), class: 'info'}}
        haml haml_path('show'), layout: false
      else
        flash[:msg] = {msg: {txt: t('edit.msg.error', data: mat(@object,'model_name')), class: 'error'}}
        haml haml_path('edit'), layout: false
      end
    end
    # @todo Document this route
    delete '/:module/:class/:id' do |m,c,id|
      handle_params(m,c,id,'delete',params)
      @object.destroy
      flash[:msg] = {msg: {txt: t('delete.msg.end', data: mat(@object,'model_name')), class: 'info'}}
      status 200
    end
    # @todo Document this route
    post '/:module/:class/:id/file_upload/:related_to' do |m,c,id,r_to|
      handle_params(m,c,id,'show',params)
      upload_object = @object.send r_to
      if upload_object.new(params[:upload]).save
        flash[:msg] = {msg: {txt: t('file_upload.msg.end'), class: 'info'}}
        "Success"
      else
        flash[:msg] = {msg: {txt: t('file_upload.msg.error'), class: 'error'}}
        "Error"
      end
    end
    # @todo Document this route
    delete '/:module/:class/:id/file_delete/:related_to/:related_id' do |m,c,id,r_to,r_id|
      handle_params(m,c,id,'show',params)
      delete_object = @object.send(r_to).find(r_id)
      if delete_object.destroy
        flash[:msg] = {msg: {txt: t('file_delete.msg.end'), class: 'info'}}
        "Success"
      else
        flash[:msg] = {msg: {txt: t('file_delete.msg.error'), class: 'error'}}
        "Error"
      end
    end
    # @todo Document this route
    post '/:module/:class/:id/file_download/:related_to/:related_id' do |m,c,id,r_to,r_id|
      handle_params(m,c,id,'show',params)
      f = @object.send(r_to).find(r_id)
      if params[:check]
        f.file_data.to_json
      else
        send_file(f.attachment.file.path,disposition: 'attachment',filename: f.file_data[:file][:name])
      end
    end
    # @todo Document this route
    get '/*' do
      method, id = params[:splat][0].split('_')
      @content   = page_content(id)
      markdown @content
    end
  end # System
end # Trst
