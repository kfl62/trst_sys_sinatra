# encoding: utf-8
module Trst
  module Haml
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

      def current_lang
        I18n.locale
      end

      def current_controller
        self.class.to_s.underscore
      end

      def current_book
        TrstBook.where(:name  => current_controller).first
      end

      def controller_path
        current_controller == 'trst_sys' ? retval = '/srv' : retval = ''
        retval
      end

      def lang_path
        current_lang == :ro ? retval = "" : retval = "/#{current_lang.to_s}"
        retval
      end

      def t(text)
        I18n.reload!
        translation = I18n.t(text)
      end

      def readable_values(o)
        keys = o.fields.keys
        r_keys = []
        keys.each do |k|
          if k =~ /_at/
            v = o.send k
            r_keys << [4,t("#{o.class.to_s.underscore}.#{k}"),v]
          elsif k =~ /_ids$/
            case k.split('_')[0]
            when 'page'
              v = []
              ary = o.send k
              ary.each{ |a| v << "#{TrstBook.page(a).chapter.name}><b>#{TrstBook.page(a).name}</b><"}
            when 'user'
              v = []
              ary = o.send k
              ary.each{ |a| v << TrstUser.find(a).login_name}
            when 'task'
              v = []
              ary = o.send k
              ary.each{ |a| v << TrstTask.find(a).name}
            end
            r_keys << [3,t("#{o.class.to_s.underscore}.#{k}"),v]
          elsif o.fields[k].type.to_s =~ /LocalizedField/
            v = o.send k
            v = v + "<span class='flri small'>(*ro,en,hu)</span>"
            r_keys << [2,t("#{o.class.to_s.underscore}.#{k}"),v]
          else
           v = o.send k
           r_keys << [1,t("#{o.class.to_s.underscore}.#{k}"),v]
          end
        end
        return r_keys.sort
      end

    end
  end
end
