# encoding: utf-8
class TrstUtils < Sinatra::Base

  get '/msg' do
    flash[:msg]
  end

  get '/lang/:lang' do |l|
    Sinatra::Base.set(:lang, l.to_sym)
    logged_in? ? path = '/srv' : path = '/'
    redirect path
  end

end
