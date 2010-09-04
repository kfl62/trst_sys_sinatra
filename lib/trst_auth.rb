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
      if Rack.const_defined?('Flash')
        flash[:notice] = "Login successful."
      end
      if session[:return_to]
        redirect_url = session[:return_to]
        session[:return_to] = false
        redirect redirect_url
      else
        redirect '/srv'
      end
    else
      if Rack.const_defined?('Flash')
        flash[:notice] = "The email or password you entered is incorrect."
      end
      redirect '/'
    end
  end
  get '/logout' do
    session[:user] = nil
    if Rack.const_defined?('Flash')
      flash[:notice] = "Logout successful."
    end
    redirect '/'
  end

  get '/adduser' do
    haml :"/auth/adduser", :layout => false
  end

  post '/adduser' do
    @user = TrstUser.set(params[:user])
    if @user.valid && @user.id
      session[:user] = @user.id
      if Rack.const_defined?('Flash')
        flash[:notice] = "Account created."
      end
      redirect '/srv'
    else
      if Rack.const_defined?('Flash')
        flash[:notice] = "There were some problems creating your account: #{@user.errors}."
      end
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
      if Rack.const_defined?('Flash')
        flash[:notice] = 'Account updated.'
      end
      redirect '/'
    else
      if Rack.const_defined?('Flash')
        flash[:notice] = "Whoops, looks like there were some problems with your updates: #{user.errors}."
      end
      redirect "/users/#{user.id}/edit?" + hash_to_query_string(user_attributes)
    end
  end

  get '/users/:id/delete' do
    login_required
    redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]
    if TrstUser.delete(params[:id])
      if Rack.const_defined?('Flash')
        flash[:notice] = "User deleted."
      end
    else
      if Rack.const_defined?('Flash')
        flash[:notice] = "Deletion failed."
      end
    end
    redirect '/'
  end
  
end

