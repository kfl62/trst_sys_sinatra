# encoding: utf-8
module Trst
  # ##Description
  # ##Scope
  # @todo documentation
  class Public  < Sinatra::Base
    register Sinatra::Flash
    register Trst::Helpers
    set :views, File.join(Trst.views,'public',Trst.firm.public['views'])

    if Trst.env == 'development'
      use Assets::Stylesheets
      use Assets::Javascripts
    end

    get '/' do
      book = Book.find_by(slug: 'trst_public')
      @chapters = book.chapters
      start_pg  = book.chapters.find_by(slug: 'home')
      @content  = page_content(start_pg.id.to_s)
      begin
        markdown @content,layout_engine: :haml,layout: Trst.firm.public['layout'].to_sym
      rescue
        markdown @content,layout_engine: :haml,layout: Trst.firm.public['layout'].to_sym,layout_options: {views: File.join(Trst.views,'public',Trst.firm.public['views'])},views: File.join(Trst.views, 'public')
      end
    end

    get '/*' do |page|
      method, id = params[:splat][0].split('_')
      @content   = page_content(id)
      begin
        markdown @content
      rescue
        markdown @content,views: File.join(Trst.views, 'public')
      end
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
