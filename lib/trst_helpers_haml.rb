# encoding: utf-8
=begin
#Haml helpers
Just for convenience (namespace)
=end
module Trst
  # #Haml helpers
  #Just for convenience (namespace)
  module Haml
    # #Haml helpers
    # Helper methods used in views
    module Helpers
      # self.extend self
      # lol stolen again :), from <http://gist.github.com/119874>
      #
      # stolen from <http://github.com/cschneid/irclogger/blob/master/lib/partials.rb><br>
      # and made a lot more robust by me this implementation uses erb by default.<br>
      # If you want to use any other template mechanism then replace `erb` on<br>
      # line 13 and line 17 with `haml` or whatever.
      # @author [lenary](http://gist.github.com/lenary)
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

      # @return [String]
      # @todo Document this method
      def current_host
        request.host
      end

      # @return [String]
      # @todo Document this method
      def current_lang
        I18n.locale
      end

      # @return [String]
      # @todo Document this method
      def current_controller
        self.class.to_s.underscore
      end

      # @return [TrstBook]
      # @todo Document this method
      def current_book
        TrstBook.where(:name  => current_controller).first
      end

      # @return [String]
      # @todo Document this method
      def current_title(task,verb,action=nil)
        case action
        when nil
          title = task.title.empty? ? "...?..." : task.title
          title += " - "
          title += t("button.#{verb}",:default => "")
        else
          title = t("#{task.class.name.underscore}.relations.#{action}.#{verb}")
        end
        return title
      end

      # @todo Document this method
      def tr_body(verb,data,task = nil,object = nil)
        haml_tag "tr.#{data[:css]}" do
          td_label(data[:css],data[:label])
          td_get_value(data[:css],data[:value]) if verb == 'get'
          td_put_value(data,task,object) if verb == 'put'
        end
      end

      # @todo Document this method
      def td_label(css,label)
        haml_tag :td do
          haml_tag :span do
            label += "<sup>*</sup>" if css == "localized"
            haml_concat label
          end
        end
      end

      # @todo Document this method
      def td_get_value(css,value)
        haml_tag :td do
          value = value.join(', ') if css == "array"
          value = value[0].join(', ') if css == "relations"
          value = (value.nil? ? '...?...' : value["#{current_lang}"]) if css == "localized"
          haml_tag :span, value,  :class => "limit-width"
        end
      end

      # @todo Document this method
      def td_put_value(data,task,object)
        haml_tag :td do
          case data[:css]
          when /normal|integer/
            haml_tag :input,
                     :name => input_name(task,data[:name]),
                     :value => data[:value]
          when 'localized'
            haml_tag :input,
                     :name => input_name(task,data[:name]),
                     :value => data[:value].nil? ? '...?...' : data[:value]["#{current_lang}"]
          when 'relations'
            haml_tag :span, data[:value][0].join(', '), :class => "limit-width"
            haml_tag :input, :type  => "hidden",
                     :name => input_name(task,data[:name]),
                     :value => data[:value][1].join(',')
            haml_tag :input, :type  => "hidden",
                     :value => "/srv/tsk,#{task.id.to_s},'put',#{object.id.to_s}"
            haml_tag :span, :class => "db-relations-del",
                     :'data-fieldname' => data[:name].split(',').last,
                     :onclick => "trst.task.relations.init(this)"
            haml_tag :span, :class => "db-relations-add",
                     :'data-fieldname' => data[:name].split(',').last,
                     :onclick => "trst.task.relations.init(this)"
          when 'boolean'
            haml_tag :input, "Da", :type => "radio",
                     :name => input_name(task,data[:name]),
                     :checked => data[:value],
                     :value => "true"
            haml_tag :input, "Nu", :type => "radio",
                     :name => input_name(task,data[:name]),
                     :checked => !data[:value],
                     :value => "false"
            when 'admin'
              if current_user.admin?
                haml_tag :input,
                         :name => input_name(task,data[:name]),
                         :value => data[:value]
              else
                haml_tag :span, data[:value],  :class => "limit-width"
              end
          else
            haml_tag :span, data[:value], :class => "limit-width"
          end
        end
      end

      # @return [String]
      # @todo Document this method
      def input_name(task,name)
        model = task.target.split('.')[0].underscore
        retval = ""
        name.split(',').each do |n|
          retval += "[#{n}]"
        end
        retval += "[]" if name.end_with? ","
        retval = "[#{model}]#{retval}"
        return retval
      end
      # @todo
      def option_name(o)
        case o.name
        when Array
          if o.name.length == 2
            name = o.name.join(' ')
          else
            name = o.name.first
          end
        else
          name = o.name
        end
        return name
      end
      # get buttons for specific `action`
      # @example
      #   !!!haml
      #   - current_buttons('delete').each do |verb|
      #     %span{:class => "button #{verb}", :onclick => current_js(verb)}= t("button.#{verb}")
      #   #=> renders Delete and Cancel buttons
      # @param [String] action any of `add, del, delete, filter, post, put`
      # @return [Array]
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
        when 'pdf'
          %w{cancel print}
        end
      end

      # @return [String]
      # @todo Document this method
      def current_xhr(button,id,action,target_id,params = nil)
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
        when 'pdf'
          verb = button
        end
        if params
          target_id = "#{target_id.to_s}?target=#{params[:target]}&child_id=#{params[:child_id]}" if params[:target]
          target_id = "#{target_id.to_s}?id_pn=#{params[:id_pn]}" if params[:id_pn]
          target_id = "#{target_id.to_s}?client_id=#{params[:client_id]}&transporter_id=#{params[:transporter_id]}" if params[:client_id]
        end
        retval = "trst.task.init('#{id}','#{verb}','#{target_id}')"
        retval = 'trst.task.destroy()' if button == 'cancel'
        return retval
      end

      # @return [String]
      # @todo Document this method
      def current_js(action)
        retval = "trst.task.relations.#{action}()"
        retval = "trst.task.relations.destroy()" if action == 'cancel'
        return retval
      end

      # get the current controller path
      # @example
      #   "#{lang_path}#{controller_path}" #=> "/hu/srv"
      # @return [String] used to format url
      def controller_path
        current_controller == 'trst_sys' ? retval = '/srv' : retval = ''
        retval
      end

      # get the current language path
      # @example
      #   "#{lang_path}#{controller_path}" #=> "/en/srv"
      # @return [String] used to format url
       def lang_path
        current_lang == :ro ? retval = "" : retval = "/#{current_lang.to_s}"
        retval
      end

      # @return [String]
      # @todo Document this method
      def t(text, options={})
        I18n.reload!
        translation = I18n.t(text,options)
      end

    end
  end
end

