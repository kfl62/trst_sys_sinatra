# encoding: utf-8
=begin
#Handling utilities#
=end
class TrstUtils < Sinatra::Base
  register Sinatra::Flash
  # @todo Document this method
  get '/msg/:what/:kind' do |w,k|
    if w == 'flash'
      retval = flash[:msg]
    else
      retval = {:msg => {:txt => I18n.t(w, :data => params[:data]), :class => k}}.to_json
    end
    retval
  end
  # @todo Document this method
  get '/lang/:lang' do |l|
    I18n.locale = l.to_sym
    path = logged_in? ?  "#{lang_path}/srv" :  "#{lang_path}/"
    flash[:msg] = {:msg => {:txt => I18n.t('lang.change'), :class => "info"}}.to_json
    redirect path
  end
  # @todo
  get '/search/:model' do |m|
    model = m.constantize
    unit = current_user.unit_id || session[:unit_id]
    if params[:dn]
      model.auto_search(unit,true).to_json
    else
      model.auto_search(unit).to_json
    end
  end
end
