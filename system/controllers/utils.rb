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
      if user = User.authenticate(params[:name], params[:password])
        session[:user] = user.id
        flash[:msg] = {:msg => {:txt => t('login.ok'), :class => "loading"}}
        redirect "#{lp}/sys"
      else
        flash[:msg] = {:msg => {:txt => t('login.error'), :class => "error"}}
        redirect "#{lp}/"
      end
    end
    # Logout
    get '/logout' do
      session[:user] = nil
      flash[:msg] = {:msg => {:txt =>t('login.logout'), :class => "loading"}}
      redirect "#{lp}/"
    end
    # @todo Document this method
    post '/msg' do
      w, k, d = params[:what], params[:kind], params[:data]
      if w == 'flash'
        retval = flash[:msg] || {:msg => {:txt => t('msg.loading'), :class => "loading"}}
      else
        retval = {:msg => {:txt => t(w, :data => d), :class => k}}
      end
      retval.to_json
    end
    # @todo Document this method
    get '/lang/:lang' do |l|
      I18n.locale = l.to_sym
      path = session[:user].nil? ?  "#{lp}/" :  "#{lp}/sys"
      flash[:msg] = {:msg => {:txt => t('lang.change'), :class => "info"}}
      redirect path
    end
    # @todo Document this method
    get '/search/:model' do |m|
      model = m.constantize
      unit = User.find(session[:user]).unit_id || session[:unit_id]
      if params[:dn]
        model.auto_search(unit,true).to_json
      else
        model.auto_search(unit).to_json
      end
    end
    # @todo
    get '/relations/:model/:class/:id/:rel_to' do |m,c,id,r|
      parent = "#{m}/#{r}".classify.constantize
      child  = "#{m}/#{c}".classify.constantize
      @parent = "#{m}_#{r}"
      @child  = "#{m}/#{c}"
      @object = parent.where(:_id.nin => (child.send :"#{r.split('_').last}_ids", id))
      haml :relations, :layout => false
    end
 end # Utils
end # Trst
