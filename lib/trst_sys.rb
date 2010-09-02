# encoding: utf-8
class TrstSys < Sinatra::Base

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  get '/' do
    haml :"/trst_pub/index", :layout => request.xhr? ? false : :'layouts/trst_sys'
  end

  get '/:page' do |pg|
    page = pg.split('.')
    page.empty? ? page = 'index' : page = page[0]
    haml :"/trst_pub/#{page}", :layout => request.xhr? ? false : :'layouts/trst_sys'
  end

end
