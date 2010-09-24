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

      def current_title(task,verb,action=nil)
        case action
        when nil
          title = task.title.empty? ? "...?..." : task.title
          title += " - "
          title += t("button.#{verb}")
        else
          title = t("#{task.class.name.underscore}.relations.#{action}.#{verb}")
        end
        return title
      end

      def input_name(task,name)
        model = task.target.split('.')[0].underscore
        retval = ""
        name.split(',').each do |n|
          retval += "[#{n}]"
        end
        retval = "[#{model}]#{retval}"
        return retval
      end

      def current_buttons(action)
        case action
        when 'get'
          %w{put delete cancel post}
        when 'delete'
          %w{delete cancel}
        when 'put'
          %w{save cancel delete}
        when 'post'
          %w{post cancel}
        when 'filter'
          %w{post cancel}
        when 'add' # relations
          %w{add cancel}
        when 'del' # relations
          %w{del cancel}
        end
      end

      def current_xhr(button,id,action,target_id)
        case action
        when /filter|get/
          verb = button
          target_id = "new" if button == 'post'
        when 'post'
          target_id = "new"
          verb = button
        when 'put'
          verb = 'put' if button == 'save'
          verb = 'delete' if button == 'delete'
        when 'delete'
          verb = button
        end
        retval = "trst.task.init('#{id}','#{verb}','#{target_id}')"
        retval = 'trst.task.destroy()' if button == 'cancel'
        return retval
      end
      
      def current_js(action)
        retval = "trst.task.relations.#{action}()"
        retval = "trst.task.relations.destroy()" if action == 'cancel'
        return retval
      end

      def controller_path
        current_controller == 'trst_sys' ? retval = '/srv' : retval = ''
        retval
      end

      def lang_path
        current_lang == :ro ? retval = "" : retval = "/#{current_lang.to_s}"
        retval
      end

      def t(text, options={})
        I18n.reload!
        translation = I18n.t(text,options)
      end

    end
  end
end

