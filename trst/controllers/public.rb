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
      book = Book.where(name: 'trst_pub').first
      @chapters = book.chapters
      @page = book.chapters.where(slug: 'home').first
      haml :page
    end

    get '/*' do |page|
      book = Book.where(:name  => "trst_pub").first
      if request.xhr?
        method, id = params[:splat][0].split('_')
        @page = Book.send method, id
        haml :page, :layout  => false
      else
        #code below just for testing :) real route above
        @chapters = book.chapters
        if params[:splat][0] == ""
          @page = book.chapters.where(:slug  => "home").first
        elsif File.basename(params[:splat][0]) == "index.html"
          if File.dirname(params[:splat][0]) == "."
            @page = book.chapters.where(:slug  => "home").first
          else
            @page = book.chapters.where(:slug  => File.dirname(params[:splat][0])).first
          end
        else
          chapter = @chapters.where(:slug  => File.dirname(params[:splat][0])).first
          slug = File.basename(params[:splat][0]).gsub(/(TrustSys-#{chapter.slug.camelize}-)|(.html)/,"")
          @page = chapter.pages.where(:slug => slug).first
        end
        haml :page
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
