# encoding: utf-8
=begin
#Handling TrustSys pages#
=end
class TrstSys < Sinatra::Base
  # @todo Document this method
  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"stylesheets/#{params[:name]}", Compass.sass_engine_options
  end
  # @todo Document this method   
  get ('/pdf/:template') do
    filename = params[:filename]
    filename += '.pdf'
    headers({'Content-Type' => 'application/pdf',
             'Content-Description' => 'File Transfer',
             'Content-Transfer-Encoding' => 'binary',
             'Content-Disposition' => "attachment;filename=\"#{filename}\"",
             'Expires' => '0',
             'Pragma' => 'public'})
    haml :"trst_pdf/#{params[:template]}", :layout => false
  end
  # @todo Document this method
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
