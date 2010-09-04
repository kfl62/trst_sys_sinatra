# encoding: utf-8
class TrstUtils < Sinatra::Base

  get '/msg' do
    flash[:msg]
  end

end
