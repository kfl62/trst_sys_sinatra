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

    before do
      if session[:user]
        @current_user = User.find(session[:user])
        I18n.reload! if Trst.env == 'development'
      else
        flash[:msg] = {msg: {txt: t('login.required'), class: 'error'}}
        redirect  "#{lp}/"
      end
    end

    # @todo Document this route
    get '/' do
      book = Book.where(name: 'trst_sys').first
      @chapters = book.chapters
      @page = book.chapters.where(slug: 'my_page').first
      haml :page
    end
    # @todo Document this route
    get '/tasks/:page_id' do |page|
      @page = Book.page(page)
      @tasks = (@page.task_ids & @current_user.task_ids).map{|id| Task.find(id)}
      haml :tasks, layout: false
    end
    # @todo Document this route
    get '/*' do
      method, id = params[:splat][0].split('_')
      @page = Book.send method, id
      haml :page, layout: false
    end
  end # System
end # Trst
