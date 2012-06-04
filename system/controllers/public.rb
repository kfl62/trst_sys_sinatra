# encoding: utf-8
module Trst
  # ##Description
  # ##Scope
  # @todo documentation
  class Public  < Sinatra::Base
    register Sinatra::Flash
    register Trst::Helpers
    set :views, File.join(Trst.views, 'public')

    if Trst.env == 'development'
      use Assets::Stylesheets
      use Assets::Javascripts
    end

    get '/' do
      book = Book.find_by(slug: 'trst_public')
      @chapters = book.chapters
      @page = book.chapters.find_by(slug: 'home')
      haml :page, layout: Trst.firm.layout.to_sym
    end

    get '/*' do |page|
      book = Book.find_by(slug: 'trst_public')
      if request.xhr?
        method, id = params[:splat][0].split('_')
        @page = Book.send method, id
        haml :page, layout: false
      else
        #code below just for testing :) real route above
        @chapters = book.chapters
        if params[:splat][0] == ""
          @page = book.chapters.find_by(slug: 'home')
        elsif File.basename(params[:splat][0]) == "index.html"
          if File.dirname(params[:splat][0]) == "."
            @page = book.chapters.find_by(slug: 'home')
          else
            @page = book.chapters.find_by(slug: File.dirname(params[:splat][0]).underscore)
          end
        else
          chapter = @chapters.find_by(slug: File.dirname(params[:splat][0]).underscore)
          slug = File.basename(params[:splat][0]).gsub(/(trustsys-#{chapter.slug.dasherize}-)|(.html)/,"")
          @page = chapter.pages.find_by(slug: slug.underscore)
        end
        haml :page, layout: Trst.firm.layout.to_sym
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
