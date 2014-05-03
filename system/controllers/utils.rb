# encoding: utf-8
module Trst
  # ##Description
  # ##Scope
  # @todo documentation
  class Utils < Sinatra::Base
    register Sinatra::Flash
    register Trst::Helpers
    set :views, File.join(Trst.views, 'utils')

    if Trst.env == 'development'
      use Assets::Stylesheets
      use Assets::Javascripts
    end

    # Authentication
    get '/login' do
      haml :login, :layout  => false
    end
    post '/login' do
      if Date.today == Date.new(*params[:cdate].split('-').map(&:to_i))
        if user = User.authenticate(params[:name], params[:password])
          session[:user] = user.id
          user.set(:last_login, Time.now)
          user.login(request.ip) if user.methods.include?(:login)
          flash[:msg] = {msg: {txt: t('msg.login.start'), class: "loading"}}
          redirect "#{lp}/sys"
        else
          flash[:msg] = {msg: {txt: t('msg.login.error'), class: "error"}}
          redirect "#{lp}/"
        end
      else
        flash[:msg] = {msg: {txt: t('msg.login.error_date'), class: "error"}}
        redirect "#{lp}/"
      end
    end
    # Logout
    get '/logout' do
      user = User.find(session[:user])
      user.logout if user.methods.include?(:logout)
      session[:user] = nil
      flash[:msg] = {msg: {txt:t('msg.login.end'), class: "loading"}}
      redirect "#{lp}/"
    end
    # @todo Document this method
    post '/msg' do
      w, k, d = params[:what], params[:kind], params[:data]
      if w == 'flash'
        retval = flash[:msg] || {msg: {txt: t('msg.loading'), class: "loading"}}
      else
        retval = {msg: {txt: t(w, data: d), class: k}}
      end
      retval.to_json
    end
    # @todo Document this method
    get '/lang/:lang' do |l|
      I18n.locale = l.to_sym
      path = session[:user].nil? ?  "#{lp}/" :  "#{lp}/sys"
      flash[:msg] = {msg: {txt: t('msg.lang.start'), class: "info"}}
      redirect path
    end
    # @todo Document this method
    get '/search/:model' do |m|
      model = m.constantize
      model.auto_search(params).to_json
    end
    # @todo
    get '/relations/:model/:class/:id/:rel_to' do |m,c,id,r|
      parent = "#{m}/#{r}".classify.constantize
      child  = "#{m}/#{c}".classify.constantize
      @parent = "#{m}_#{r}"
      @child  = "#{m}/#{c}"
      @object = parent.where(:_id.nin => (child.send :"#{r.split('_').last}_ids", id))
      haml :relations, layout: false
    end
    # @todo
    get '/units/:model/:class/:dialog/:unit_id' do |m,c,d,uid|
      uid == 'null' ? session[:unit_id] = nil : session[:unit_id] = uid
      handle_params(m,c,nil,d,params)
      path = "#{lp}/sys/#{m}/#{c}/#{d}"
      redirect path
    end
  end # Utils
end # Trst
