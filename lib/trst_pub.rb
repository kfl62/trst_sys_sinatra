require 'trst_conf'

class TrstPub < Sinatra::Base
  
  Dir[File.join(TrstPub.views,"layouts","*.haml")].each do |layout|
    name = layout[/([^\/]*)\.haml$/, 1].to_sym
    haml = File.read(layout)
    TrstPub.template(name) {haml}
    TrstPub.layout {haml} if name == :trst_pub
  end

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end

  get '/' do
    haml :"/trst_pub/index", :layout => !request.xhr?
  end

  get '/:page' do |pg|
    page = pg.split('.')
    page.empty? ? page = 'index' : page = page[0]
    haml :"/trst_pub/#{page}", :layout => !request.xhr?
  end

end
