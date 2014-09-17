# encoding: utf-8
module Trst
  # #Trst::Assets module
  # ##Description
  # ##Scope
  # @todo document this module
  module Assets
    # #Sass/Compass Handler
    class Stylesheets < Sinatra::Base
      set :static, true
      register  CompassInitializer

      # @todo Document this method
      get '/stylesheets/:name.css' do
        content_type 'text/css', :charset => 'utf-8'
        scss params[:name].to_sym, Compass.sass_engine_options
      end
    end
    # #Coffeescript Handler
    class Javascripts < Sinatra::Base
      set :static, true
      use Rack::Coffee,
        root: Trst.assets,
        cache_compile: true
    end
  end
end
