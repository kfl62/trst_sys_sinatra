require 'bundler/setup'
require 'sinatra/base'
require 'compass'

class TrstSys < Sinatra::Base

  configure do
    root = File.expand_path('..', File.dirname(__FILE__))
    set :root , root
    set :views, File.join(root, 'src')
    set :logging, true
    Compass.add_project_configuration(File.join(root, 'config', 'compass.rb'))
  end

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
