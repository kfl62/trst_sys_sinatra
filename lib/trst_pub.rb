# encoding: utf-8
class TrstPub < Sinatra::Base

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end


  get '/*' do
    if request.xhr?
      method, id = params[:splat][0].split('_')
      page = TrstBook.send method, id
      haml :"trst_pub/page", :layout  => false, :locals => {:page  => page}
    else
      #code below just for testing :) real route above
      book = TrstBook.where(:name  => "trst_pub").first
      if params[:splat][0] == ""
        page = book.chapters.where(:slug  => "home").first
      elsif File.basename(params[:splat][0]) == "index.html"
        if File.dirname(params[:splat][0]) == "."
          page = book.chapters.where(:slug  => "home").first
        else
          page = book.chapters.where(:slug  => File.dirname(params[:splat][0])).first
        end
      else
        chapter = book.chapters.where(:slug  => File.dirname(params[:splat][0])).first
        slug = File.basename(params[:splat][0]).gsub(/(TrustSys-#{chapter.slug.camelize}-)|(.html)/,"")
        page = chapter.pages.where(:slug => slug).first
      end
      haml :"trst_pub/page", :layout => :'/layouts/trst_pub', :locals => {:page  => page}
    end
  end

end
