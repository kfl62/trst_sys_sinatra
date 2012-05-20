# encoding: utf-8
module Trst
  # #Trst::Assets module
  # ##Description
  # ##Scope
  # @todo document this module
  module Assets
    # #Sass/Compass Handler
    class Stylesheets < Sinatra::Base
      register  CompassInitializer

      # @todo Document this method
      get '/stylesheets/:name.css' do
        content_type 'text/css', :charset => 'utf-8'
        sass params[:name].to_sym, Compass.sass_engine_options
      end
    end
    # #Coffeescript Handler
    class Javascripts < Sinatra::Base
      set :views, File.join(Trst.assets,'javascripts')

      # @todo Document this method
      get '/javascripts/:name.js' do
        content_type 'text/javascript', :charset => 'utf-8'
        coffee params[:name].to_sym
      end
    end
  end
end
