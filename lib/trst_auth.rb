# encoding: utf-8
=begin
#Handling authentication#
Just for login and logout.<br>
Only `admin` has rights to `add, delete, modify` users. In conclusion users are
handled by a `task` (which requires {TrstUser#admin?} ) with all `CRUD` operations.<br>
Each user can change his password and some settings( {TrstUser} ) using an other `task`
(accessible via `Settings` menu).
=end
class TrstAuth < Sinatra::Base

  # @todo Document this method
  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  # @todo Document this method
  get '/login' do
    haml :"/trst_auth/login", :layout => request.xhr? ? false : :'layouts/trst_pub'
  end

  # @todo Document this method
  post '/login' do
    if user = TrstUser.authenticate(params[:login_name], params[:password])
      session[:user] = user.id
      session[:tasks] = user.daily_tasks
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.login_msg'), :class => "info"}}.to_json
      redirect "#{lang_path}/srv"
    else
      flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.login_err'), :class => "error"}}.to_json
      redirect "#{lang_path}/"
    end
  end

  # @todo Document this method
  get '/logout' do
    session[:user] = nil
    session[:daily_tasks] = nil
    flash[:msg] = {:msg => {:txt => I18n.t('trst_auth.logout_msg'), :class => "info"}}.to_json
    redirect "#{lang_path}/"
  end

end

