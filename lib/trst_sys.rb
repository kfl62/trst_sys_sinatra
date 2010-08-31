require 'trst_conf'

class TrstSys < Sinatra::Base

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  get '/help' do
    "Some help"
  end

  get '/' do
    "Welcome to TrustSys application ...testing..."
  end

end
