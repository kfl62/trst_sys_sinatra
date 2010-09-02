# encoding: utf-8
module Trst
  module Helpers
   self.extend self
    # lol stolen from http://gist.github.com/119874 author http://gist.github.com/lenary
    # stolen from http://github.com/cschneid/irclogger/blob/master/lib/partials.rb
    #   and made a lot more robust by me
    # this implementation uses erb by default. if you want to use any other template mechanism
    #   then replace `erb` on line 13 and line 17 with `haml` or whatever 
    def partial(template, *args)
      template_array = template.to_s.split('/')
      template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:layout => false)
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << haml(:"#{template}", options.merge(:layout =>
          false, :locals => {template_array[-1].to_sym => member}))
        end.join("\n")
      else
        haml(:"#{template}", options)
      end
    end

    def current_host
      request.host
    end

  end
end
