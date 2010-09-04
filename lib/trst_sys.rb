# encoding: utf-8
class TrstSys < Sinatra::Base

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  get '/' do
    login_required
    haml :"/trst_sys/index", :layout => request.xhr? ? false : :'layouts/trst_sys'
  end

  get '/:page' do |pg|
    login_required
    page = pg.split('.')
    page.empty? ? page = 'index' : page = page[0]
    haml :"/trst_sys/#{page}", :layout => request.xhr? ? false : :'layouts/trst_sys'
  end

end
