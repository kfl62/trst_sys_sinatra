# encoding: utf-8
module Trst
  module Helpers
    class << self
      def registered(app)
        app.helpers self
      end
    end
    # @todo
    def partial(template, *args)
      template_array = template.to_s.split('/')
      template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(layout: false)
      if collection = options.delete(:collection) then
        collection.inject([]) do |buffer, member|
          buffer << haml(:"#{template}", options.merge(layout: false,
                                                       locals: {template_array[-1].to_sym => member}))
        end.join("\n")
      else
        haml(:"#{template}", options)
      end
    end
    # Delegates to I18n.translate with no additional functionality.
    #
    # @param [Symbol] *args
    #   The keys to retrieve.
    #
    # @return [String]
    #  The translation for the specified keys.
    #
    # @api public
    def translate(*args)
      args[0] = "#{Trst.firm.i18n_path}.#{args[0]}"
      I18n.translate(*args)
    end
    alias :t :translate
    # Delegates to I18n.localize with no additional functionality.
    #
    # @param [Symbol] *args
    #   The keys to retrieve.
    #
    # @return [String]
    #  The translation for the specified keys.
    #
    # @api public
    def localize(*args)
      I18n.localize(*args)
    end
    alias :l :localize
    ##
    # Translates attribute name for the given model.
    #
    # @param [Symbol] model
    #  The model name for the translation.
    # @param [Symbol] attribute
    #  The attribute name in the model to translate.
    #
    # @return [String] The translated attribute name for the current locale.
    #
    # @example
    #   # => t("models.account.attributes.email", :default => "Email")
    #   mat(:account, :email)
    #
    def model_attribute_translate(model, attribute)
      model = model.is_a?(Mongoid::Document) ? model.class : model
      model.human_attribute_name(attribute)
    end
    alias :mat :model_attribute_translate
    # Set language prefix for browser's path
    # @return [String]
    def localized_path
      lang = I18n.locale.to_s
      lang == "ro" ? "" : "/#{lang}"
    end
    alias :lp :localized_path
    # @todo
    def current_user
      Trst::User.find(session[:user])
    end
    # @todo
    def guess_task(path,action)
      Trst::Task.find(request.cookies['task_id'])
    end
    # @todo
    def handle_params(m,c,id,action,params)
      related_id= params[:related_id]
      @path     = "#{m}/#{c}"
      @verb     = action.split('_').first
      task      = guess_task(@path,action)
      model     = @path.classify.constantize
      related   = model.relations[task.rels] || model.relations[request.cookies['rels']]
      if related
        @related_path  = related.class_name.underscore
        related_model  = related.class_name.constantize
        @related_object= related_model.all
      end
      case action
      when 'filter'
        @object = model.all
        if related && related_id
          @object = related_model.find(related_id).send related.inverse
        end
      when 'create_get'
        @object = model.new
        if related && related_id
          @related_object= related_model.find(related_id)
          object         = @related_object.send related.inverse
          @object        = object.new
        end
      when 'create_post'
        @object = model.new(params[:"#{@path}"])
        if related && related_id
          @related_object= related_model.find(related_id)
          object         = @related_object.send related.inverse
          @object        = object.new(params[:"#{@path}"])
        end
      when 'edit_get', 'edit_put', 'show', 'delete_get', 'delete'
        @object = model.find(id)
        if related && related_id
          @related_object= related_model.find(related_id)
          object         = @related_object.send related.inverse
          @object        = object.find(id)
        end
      else
        @object = nil
      end
      # special case handling page
      if c =~ /chapter|page/
        model   = "#{m}/book".classify.constantize
        method  = c
        @object = model.send method, id
      end
      true
    end
    # @todo
    def guess_value(model,attribute,options)
      order,type,map = options.values_at(:order,:type,:map)
      method = map.nil? ? attribute : map
      value  = model.send method
      case value
      when Array, Hash
        value = map.nil? ? order.nil? ? value.join(',') : value[order] : value.map(&:last).join(', ')
      when Time
        value = l(value, format: :trst)
      when String, Integer, Float, Moped::BSON::ObjectId
        value = type == 'enum' ? mat(model,"#{attribute}_#{value}") : value
      else
        value = value.send order rescue value = ''
      end
      value
    end
    # @todo
    def guess_name(model,attribute,options)
      order,nested = options.values_at(:order,:nested)
      name  = "[#{model.class.name.underscore}]"
      name  = "[#{model._parent.class.name.underscore}]" if (nested && !model._parent.nil?)
      name  = "[#{model[model.relations.values[0].name.to_s + "_type"].underscore}]" if (nested && model._parent.nil?)
      name += (model.metadata.macro.to_s.split('_').last == "one" ? "[#{nested}_attributes]" : "[#{nested}_attributes][]") if nested
      name += "[#{attribute}]"
      name += ((order.is_a? Integer) ? "[]" : "[#{order}]") if order
      name
    end
    # @todo
    def label_for(model,attribute,options = {})
      order,type,label = options.values_at(:order,:type,:label)
      #path = model.class.name.underscore
      field = attribute
      field = "#{attribute}_#{order}" if order
      field = "#{attribute}_id" if model.respond_to?("#{attribute}_id")
      field = "#{attribute}_label" if type == 'enum'
      field = label if label
      haml_tag  :span, mat(model,field), class: 'label'
    end
    # @todo
    def td_label_for(model,attribute,options = {})
      haml_tag :td do
        label_for model,attribute,options
      end
    end
    # @todo
    def value_for(model,attribute,options = {})
      order,style = options.values_at(:order,:style)
      value = guess_value model,attribute,options
      value = '-' if value.blank?
      style ||= 'value'
      style +=  attribute =~ /^id$|_at/ ? ' ui-state-highlight' : ' ui-state-default'
      haml_tag  :span, value, class: style
    end
    # @todo
    def td_value_for(model,attribute,options = {})
      haml_tag :td do
        value_for model,attribute,options
      end
    end
    # @todo
    def input_for(model,attribute,options = {})
      id,name,value,type,order,nested,disabled,placeholder = options.values_at(:id,:name,:value,:type,:order,:nested,:disabled,:placeholder)
      type  ||= 'text'
      value ||= guess_value model,attribute,options
      name  ||= guess_name  model,attribute,options
      style   = 'ui-state-default' unless type == 'hidden'
      haml_tag :input,id: id,class: style,name: name,value: value,type: type,disabled: disabled,placeholder: placeholder
    end
    # @todo
    def td_input_for(model,attribute,options = {})
      haml_tag :td do
        input_for model,attribute,options
      end
    end
    # @todo
    def select_for(model,attribute,options = {})
      id,name,type,select_options = options.values_at(:id,:name,:type,:select_options)
      name  = guess_name model,attribute,options
      style ||= 'ui-state-default'
      haml_tag :select, id: id, class: style, name: name do
        if type == 'enum'
          select_options.each do |o|
            selected = o == model.try(attribute.to_sym)
            text = mat(model,"#{attribute}_#{o}")
            haml_tag :option, text, value: o, selected: selected
          end
        else
          haml_tag :option, t("filter.select.option", data: mat(model, attribute)), value: ''
          select_options.default_sort.each do |o|
            selected = o.view_filter.first == model.try(attribute.to_sym)
            haml_tag :option, o.view_filter.last, value: o.view_filter.first, selected: selected
          end
        end
      end
    end
    # @todo
    def td_select_for(model,attribute,options = {})
      haml_tag :td do
        select_for model,attribute,options
      end
    end
    # @todo
    def error_for(model,attribute,options = {})
      order,type = options.values_at(:order,:enum)
      value = "&nbsp;"
      messages = model.send(:errors).messages[attribute.to_sym]
      if messages
        value = model.send(:errors).messages[attribute.to_sym]
        value = model.send(:errors).messages[attribute.to_sym][order] if order
        value = value.join(",\n")
      end
      haml_tag :span, value, class: 'error'
    end
    # @todo
    def td_error_for(model,attribute,options = {})
      haml_tag :td do
        error_for model,attribute,options
      end
    end
    # @todo
    def tr_show_for(model,attribute,options = {})
      haml_tag :tr do
        td_label_for model,attribute,options
        td_value_for model,attribute,options
      end
    end
    # @todo
    def tr_input_for(model,attribute,options = {})
      haml_tag :tr do
        td_label_for   model,attribute,options
        td_input_for   model,attribute,options
        td_error_for   model,attribute,options
      end
    end
    # @todo
    def tr_select_for(model,attribute,options = {})
      haml_tag :tr do
        td_label_for   model,attribute,options
        td_select_for  model,attribute,options
        td_error_for   model,attribute,options
      end
    end
    # @todo
    def page_content(id,help = false)
      if help
        task = Trst::Task.find(id)
        path = File.join(task.goal.split('.')[0].underscore,'help')
        file = File.join(Trst.views,'system',"#{path}.md")
        md   = File.exists?(file) ? path.to_sym : task.help
      else
        page = Trst::Book.page(id) rescue Trst::Book.chapter(id)
        path = File.join('pages',I18n.locale.to_s,page.slug)
        file = File.join(Trst.views,'system',"#{path}.md")
        md   = File.exists?(file) ? path.to_sym : page.content
      end
      md
    end
    # @todo
    def haml_path(action,related = false)
      task = Trst::Task.find(request.cookies['task_id'])
      path = File.join(task.goal.split('.')[0].underscore,action)
      file = File.join(Trst.views,'system',"#{path}.haml")
      haml_path = check_haml_path(file,path)
      haml_path += '_related' if related
      haml_path = task.haml_path if task.haml_path != 'default'
      haml_path.to_sym
    end
    # @todo
    def check_haml_path(f,p)
      path = File.exists?(f) ? p : check_module(p)
      file = File.join(Trst.views,'system',"#{path}.haml")
      unless File.exists?(file)
        path = check_module(path,true)
      end
      path
    end
    # @todo
    def check_module(s,main = false)
      a = s.split('/')
      main ? a[0] = 'trst' : a.delete_at(1)
      a.join('/')
    end
 end # Helper
end # Trst
