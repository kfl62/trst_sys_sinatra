# encoding: utf-8
class TrstAuth < Sinatra::Base

  get '/users' do
    login_required
    redirect "/" unless current_user.admin?
    @users = TrstUser.all
    if @users != []
      haml :"index", :layout => false
    else
      redirect '/signup'
    end
  end

  get '/users/:id' do
    login_required
    @user = TrstUser.get(:id => params[:id])
    haml :"/trst_auth/show", :layout => false
  end

  get '/login' do
    haml :"/trst_auth/login", :layout => false
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
        redirect '/sys'
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

  get '/signup' do
    haml :"/trst_auth/signup", :layout => false
  end

  post '/signup' do
    @user = TrstUser.set(params[:user])
    if @user.valid && @user.id
      session[:user] = @user.id
      if Rack.const_defined?('Flash')
        flash[:notice] = "Account created."
      end
      redirect '/'
    else
      if Rack.const_defined?('Flash')
        flash[:notice] = "There were some problems creating your account: #{@user.errors}."
      end
      redirect '/signup?' + hash_to_query_string(params['user'])
    end
  end

  get '/users/:id/edit' do
    login_required
    redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]
    @user = TrstUser.get(:id => params[:id])
    haml :"/trst_auth/edit", :layout => false
  end

  post '/users/:id/edit' do
    login_required
    redirect "/users" unless current_user.admin? || current_user.id.to_s == params[:id]
    user = TrstUser.get(:id => params[:id])
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
    if User.delete(params[:id])
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

