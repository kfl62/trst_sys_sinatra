# encoding: utf-8
class TrstUtils < Sinatra::Base

  get '/msg/:what/:kind/:data' do |w,k,d|
    if w == 'flash'
      retval = flash[:msg]
    else
      retval = {:msg => {:txt => I18n.t(w, :data => d), :class => k}}.to_json
    end
    retval
  end

  get '/lang/:lang' do |l|
    I18n.locale = l.to_sym
    logged_in? ? path = '/srv' : path = '/'
    flash[:msg] = {:msg => {:txt => I18n.t('lang.change'), :class => "info"}}.to_json
    redirect path
  end

end
