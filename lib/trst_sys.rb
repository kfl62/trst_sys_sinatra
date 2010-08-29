require 'bundler/setup'
require 'sinatra/base'

class TrstSys < Sinatra::Base
  get '/' do
    "Welcome to TrustSys application ...testing..."
  end
end
