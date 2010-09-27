# encoding: utf-8
=begin
#Handling TrustSys pages#
=end
class TrstSys < Sinatra::Base
  #TODO missing docs
  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end
  #TODO missing docs
  get '/*' do
    login_required
    if request.xhr?
      method, id = params[:splat][0].split('_')
      page = TrstBook.send method, id
      haml :"trst_sys/page", :layout  => false, :locals => {:page  => page}
    else
      # code below just for testing :) real route above
      # TODO not working on localized real pathts
      book = TrstBook.where(:name  => "trst_sys").first
      if params[:splat][0] == ""
        page = book.chapters.where(:slug  => "my_page").first
      elsif File.basename(params[:splat][0]) == "index.html"
        if File.dirname(params[:splat][0]) == "."
          page = book.chapters.where(:slug  => "my_page").first
        else
          page = book.chapters.where(:slug  => File.dirname(params[:splat][0])).first
        end
      else
        chapter = book.chapters.where(:slug  => File.dirname(params[:splat][0])).first
        slug = File.basename(params[:splat][0]).gsub(/(TrustSys-#{chapter.slug.camelize}-)|(.html)/,"")
        page = chapter.pages.where(:slug => slug).first
      end
      haml :"trst_sys/page", :layout => :'/layouts/trst_sys', :locals => {:page  => page}
    end
  end

end
