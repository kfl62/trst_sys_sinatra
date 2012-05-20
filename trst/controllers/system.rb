# encoding: utf-8
module Trst
  # ##Description
  # ##Scope
  # @todo documentation
  class System < Sinatra::Base
    register Sinatra::Flash
    register Trst::Helpers
    set :views, File.join(Trst.views, 'system')

    if Trst.env == 'development'
      use Assets::Stylesheets
      use Assets::Javascripts
    end

    get '/' do
      haml "Hello"
    end

    get '/:page' do |page|
      haml :"#{page}", :layout => !request.xhr?
    end
    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     haml :'errors/404'
    #   end
    #
    #   error 505 do
    #     haml :'errors/505'
    #   end
    #
  end
end
