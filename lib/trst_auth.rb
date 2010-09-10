# encoding: utf-8
class TrstAuth < Sinatra::Base

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  get '/users' do
    login_required
    redirect "/" unless current_user.admin?
    @users = TrstUser.all
    if @users != []
      haml :"/trst_auth/index", :layout => false
    else
      redirect '/adduser'
    end
  end

  get '/users/:id' do
    login_required
    @user = TrstUser.find(params[:id])
    haml :"/trst_auth/show", :layout => false
  end

  get '/login' do
    haml :"/trst_auth/login", :layout => request.xhr? ? false : :'layouts/trst_pub'
  end

  post '/login' do
    if user = TrstUser.authenticate(params[:login_name], params[:password])
      session[:user] = user.id
      session[:tasks] = user.daily_tasks
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.login_msg'), :class => "info"}}.to_json
    if session[:return_to]
        redirect_url = session[:return_to]
        session[:return_to] = false
        redirect redirect_url
      else
        redirect "#{lang_path}/srv"
      end
    else
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.login_err'), :class => "error"}}.to_json
      redirect "#{lang_path}/"
    end
  end
  get '/logout' do
    session[:user] = nil
    session[:daily_tasks] = nil
    flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.logout_msg'), :class => "info"}}.to_json
    redirect "#{lang_path}/"
  end

  get '/adduser' do
    haml :"/auth/adduser", :layout => false
  end

  post '/adduser' do
    @user = TrstUser.set(params[:user])
    if @user.valid && @user.id
      session[:user] = @user.id
      flash[:msg] =  {:msg => {:txt => I18n.t('trst_auth.adduser_msg'), :class => "info"}}.to_json
      redirect "#{lang_path}/srv"
    else
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.adduser_msg') + @user.errors, :class => "error"}}.to_json
      redirect '/auth/adduser?' + hash_to_query_string(params['user'])
    end
  end

  get '/users/:id/edit' do
    login_required
    redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]
    @user = TrstUser.find(params[:id])
    haml :"/trst_auth/edit", :layout => false
  end

  post '/users/:id/edit' do
    login_required
    redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]
    user = TrstUser.find(params[:id])
    user_attributes = params[:user]
    if params[:user][:password] == ""
        user_attributes.delete("password")
        user_attributes.delete("password_confirmation")
    end
    if user.update(user_attributes)
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.edituser_msg'), :class => "info"}}.to_json
      redirect '/'
    else
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.edituser_err') + @user.errors,:class => "error"}}.to_json
      redirect "/users/#{user.id}/edit?" + hash_to_query_string(user_attributes)
    end
  end

  get '/users/:id/delete' do
    login_required
    redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]
    if TrstUser.delete(params[:id])
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.deleteuser_msg'), :class => "info"}}.to_json
    else
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.deleteuser_err'), :class => "error"}}.to_json
    end
    redirect '/'
  end

end

