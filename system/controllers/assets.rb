# encoding: utf-8
module Trst
  # #Trst::Assets module
  # ##Description
  # ##Scope
  # @todo document this module
  module Assets
    class Stylesheets < Sinatra::Base
      set :static, true
      set :scss, { :cache_location => './tmp/sass-cache' }
      get '/stylesheets/:name.css' do
        content_type 'text/css', :charset => 'utf-8'
        scss params[:name].to_sym, :views => "#{TRST_ROOT}/system/assets/stylesheets"
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
