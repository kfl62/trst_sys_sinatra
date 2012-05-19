# encoding: utf-8
module Trst
  # ##Description
  # ##Scope
  # @todo documentation
  class Utils < Sinatra::Base
    register Sinatra::Flash
    register Trst::Helpers
    set :views, File.join(Trst.views, 'utils')

    if Trst.env == 'development'
      use Assets::Stylesheets
      use Assets::Javascripts
    end
 end # Utils
end # Trst
