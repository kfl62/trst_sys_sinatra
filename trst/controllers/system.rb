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
        @current_user = User.find(session[:user])
        I18n.reload! if Trst.env == 'development'
      else
        flash[:msg] = {msg: {txt: t('login.required'), class: 'error'}}
        redirect  "#{lp}/"
      end
    end

    # @todo Document this route
    get '/' do
      book = Book.where(name: 'trst_sys').first
      @chapters = book.chapters
      @page = book.chapters.where(slug: 'my_page').first
      haml :page
    end
    # @todo Document this route
    get '/tasks/:page_id' do |page|
      @page = Book.page(page)
      @tasks = (@page.task_ids & @current_user.task_ids).map{|id| Task.find(id)}
      haml :tasks, layout: false
    end
    # @todo Document this route
    get '/:module/:class/filter' do |m,c|
      handle_params(m,c,nil,'filter',params)
      haml_path = @related_object.nil? ? 'trst/filter' : 'trst/filter_related'
      haml :"#{haml_path}", layout: false
    end
    # @todo Document this route
    get '/:module/:class/create' do |m,c|
      handle_params(m,c,nil,'create_get',params)
      haml :'trst/create', layout: false
    end
     # @todo Document this route
    post '/:module/:class/create' do |m,c|
      handle_params(m,c,nil,'create_post',params)
      if @object.save
        flash[:msg] = {msg: {txt: t('create.msg.end', data: mat(@object,'model_name')), class: 'info'}}
        haml :'trst/show', layout: false
      else
        flash[:msg] = {msg: {txt: t('create.msg.error', data: mat(@object,'model_name')), class: 'error'}}
        @create_error = true
        haml :'trst/create', layout: false
      end
    end
    # @todo Document this route
    get '/:module/:class/edit/:id' do |m,c,id|
      handle_params(m,c,id,'edit_get',params)
      haml :'trst/edit', layout: false
    end
    # @todo Document this route
    get '/:module/:class/delete/:id' do |m,c,id|
      handle_params(m,c,id,'delete_get',params)
      haml :'trst/delete', layout: false
    end
    # @todo Document this route
    get '/:module/:class/:id' do |m,c,id|
      handle_params(m,c,id,'show',params)
      haml :'trst/show', layout: false
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
        haml :'trst/show', layout: false
      else
        flash[:msg] = {msg: {txt: t('edit.msg.error', data: mat(@object,'model_name')), class: 'error'}}
        haml :'trst/edit', layout: false
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
      @page = Book.send method, id
      haml :page, layout: false
    end
  end # System
end # Trst
