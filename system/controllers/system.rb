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
        if Time.now > Time.now.end_of_month - 4.hours
          flash[:msg] = {msg: {txt: t('msg.login.monthly_revision'), cls: 'error'}}
          redirect  "#{lp}/"
        end unless @current_user.root?
      else
        flash[:msg] = {msg: {txt: t('msg.login.required'), cls: 'error'}}
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
      haml @content, layout: false
    end
    # @todo Document this route
    get '/partial/:m/:f/:v' do |m,f,v|
      haml :"#{m}/#{f}/#{v}", layout: false
    end
    # @todo Document this route
    post '/session/:key/:value' do |k,v|
      session[k.to_sym] = (v == 'null') ? nil : v
    end
    # @todo Document this route
    get /^\/([\/\p{L}\p{Pc}\p{Pd}]*)\/([\p{L}\p{Pc}\p{Pd}]*)\/(filter|query|repair|print|create)/ do |m,c,a|
      case a
      when /filter|query|repair/
        handle_params(m,c,nil,a,params)
        haml haml_path(a,"#{m}/#{c}",!@related_object.nil?), layout: false
      when /create/
        handle_params(m,c,nil,'create_get',params)
        haml haml_path(a,"#{m}/#{c}"), layout: false
      when /print/
        id    = params[:id].nil? ? nil : params[:id]
        action= params[:id].nil? ? 'report' : 'print'
        handle_params(m,c,id,action,params) unless params[:rb]
        file = params[:rb] ? "#{m}/#{c}/#{params[:rb]}".to_sym : haml_path('pdf',"#{m}/#{c}")
        if params['report']
          haml file, layout: false
        else
          file_name = params[:fn] ? params[:fn] : (@object.file_name rescue 'print')
          headers({#'Content-Type' => 'application/pdf',
                   'Content-Description' => 'File Transfer',
                   'Content-Transfer-Encoding' => 'binary',
                   'Content-Disposition' => "attachment;filename=\"#{file_name}.pdf\"",
                   'Set-Cookie' => 'fileDownload=true; path=/',
                   'Expires' => '0',
                   'Pragma' => 'public'})
          require 'prawn/measurement_extensions'
          require "prawn/templates"
          #require 'prawn/table' # hotfix v0.3.1
          pdf file, layout: false
        end
      end
    end
    # @todo Document this route
    get /^\/([\/\p{L}\p{Pc}\p{Pd}]*)\/([\p{L}\p{Pc}\p{Pd}]*)\/(edit|delete)\/(\w{24})/ do |m,c,a,id|
      handle_params(m,c,id,"#{a}_get",params)
      haml haml_path(a,"#{m}/#{c}"), layout: false
    end
    get /^\/([\/\p{L}\p{Pc}\p{Pd}]*)\/([\p{L}\p{Pc}\p{Pd}]*)\/(\w{24})/ do |m,c,id|
      handle_params(m,c,id,'show',params)
      haml haml_path('show',"#{m}/#{c}"), layout: false
    end
    # @todo Document this route
    post /^\/([\/\p{L}\p{Pc}\p{Pd}]*)\/([\p{L}\p{Pc}\p{Pd}]*)\/(create)/ do |m,c,a|
      handle_params(m,c,nil,'create_post',params)
      if @object.save
        flash[:msg] = {msg: {txt: t('msg.create.end', data: mat(@object,'model_name')), cls: 'info'}}
        haml haml_path('show',"#{m}/#{c}"), layout: false
      else
        flash[:msg] = {msg: {txt: t('msg.create.error', data: mat(@object,'model_name')), cls: 'error'}}
        @create_error = true
        haml haml_path(a,"#{m}/#{c}"), layout: false
      end
    end
    # @todo Document this route
    put /^\/([\/\p{L}\p{Pc}\p{Pd}]*)\/([\p{L}\p{Pc}\p{Pd}]*)\/(\w{24})/ do |m,c,id|
      handle_params(m,c,id,'edit_put',params)
      if @object.update_attributes(params[:"#{@path}"])
        flash[:msg] = {msg: {txt: t('msg.edit.end', data: mat(@object,'model_name')), cls: 'info'}}
        haml haml_path('show',"#{m}/#{c}"), layout: false
      else
        flash[:msg] = {msg: {txt: t('msg.edit.error', data: mat(@object,'model_name')), cls: 'error'}}
        haml haml_path('edit',"#{m}/#{c}"), layout: false
      end
    end
    # @todo Document this route
    delete /^\/([\/\p{L}\p{Pc}\p{Pd}]*)\/([\p{L}\p{Pc}\p{Pd}]*)\/(\w{24})/ do |m,c,id|
      handle_params(m,c,id,'delete',params)
      @object.destroy
      flash[:msg] = {msg: {txt: t('msg.delete.end', data: mat(@object,'model_name')), cls: 'info'}}
      status 200
    end
    # @todo Document this route
    get '/:module/:class/:id/tab/:what/:verb' do |m,c,id,w,v|
      handle_params(m,c,id,v,params)
      haml :"#{m}/#{c}/_#{w}", layout: false
    end
    # @todo Document this route
    post '/:module/:class/:id/file_upload/:related_to' do |m,c,id,r_to|
      handle_params(m,c,id,'show',params)
      upload_object = @object.send r_to
      if upload_object.new(params[:upload]).save
        flash[:msg] = {msg: {txt: t('msg.file_upload.end'), cls: 'info'}}
        "Success"
      else
        flash[:msg] = {msg: {txt: t('msg.file_upload.error'), cls: 'error'}}
        "Error"
      end
    end
    # @todo Document this route
    delete '/:module/:class/:id/file_delete/:related_to/:related_id' do |m,c,id,r_to,r_id|
      handle_params(m,c,id,'show',params)
      delete_object = @object.send(r_to).find(r_id)
      if delete_object.destroy
        flash[:msg] = {msg: {txt: t('msg.file_delete.end'), cls: 'info'}}
        "Success"
      else
        flash[:msg] = {msg: {txt: t('msg.file_delete.error'), cls: 'error'}}
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
      if (Moped::BSON::ObjectId.from_string(id) rescue false)
        @content   = page_content(id)
        markdown @content
      else
        redirect "#{lp}/"
      end
    end
  end # System
end # Trst
