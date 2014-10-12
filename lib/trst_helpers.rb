# encoding: utf-8
module Trst
  module Helpers
    class << self
      def registered(app)
        app.helpers self
      end
    end
    # @todo document this method
    def pdf(*args)
      render(:rb, *args)
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
    # @todo
    def model_name
      mat(@object, 'model_name')
    end
    # Set language prefix for browser's path
    # @return [String]
    def localized_path
      lang = I18n.locale.to_s
      lang == "ro" ? "" : "/#{lang}"
    end
    alias :lp :localized_path
    # @todo
    def handle_params(m,c,id,action,params)
      r_id    = params[:r_id] unless params[:r_id] == 'null'
      @path   = "#{m}/#{c}"
      @verb   = action.split('_').first
      @task   = Trst::Task.find(session[:task_id])
      model   = @path.classify.constantize
      related = model.relations[@task.rels] || model.relations[session[:r_mdl]]
      if related
        @related_path  = related.class_name.underscore
        related_model  = related.class_name.constantize
        related_one    = related_model.relations[related.inverse_of.to_s].macro.to_s.split('_')[1] == 'one'
        @related_object= related_model.all
      end
      case action
      when 'filter', 'query', 'repair', 'report'
        @object = model.all
        if related && r_id
          @object = related_model.find(r_id).send related.inverse_of
        end
      when 'create_get'
        @object = model.new
        if related && r_id
          @related_object = related_model.find(r_id)
          if related_one
            @object = @related_object.send(:"build_#{related.inverse_of.to_s}")
          else
            object  = @related_object.send related.inverse_of
            @object = object.new
          end
        end
      when 'create_post'
        @object = model.new(params[:"#{@path}"])
        if related && r_id
          @related_object= related_model.find(r_id)
          if related_one
            @object = @related_object.send(:"build_#{related.inverse_of.to_s}")
            @object.update_attributes(params[:"#{@path}"])
          else
            object  = @related_object.send related.inverse_of
            @object = object.new(params[:"#{@path}"])
          end
        end
      when 'edit_get', 'edit_put', 'show', 'delete_get', 'delete', 'print'
        @object = model.find(id)
        if related && r_id
          @related_object= related_model.find(r_id)
          object         = @related_object.send related.inverse_of
          @object        = related_one ? object : object.find(id)
        end
      else
        @object = nil
      end
      # special case handling page
      if c =~ /chapter|page/
        model   = "#{m}/book".classify.constantize
        method  = c
        @object = model.send method, id
      end unless action =~ /filter|create/
      true
    end
    # @todo
    def guess_value(model,attribute,options)
      order,type,map = options[:guess].try(:values_at,:order,:type,:map)
      method= map.nil? ? attribute : map
      value = options[:tag].try(:delete,:value) || model.send(method)
      case value
      when Array, Hash
        value = map.nil? ? (order.nil? ? value.join(',') : value[order]) : value.map(&:last).join(', ')
      when Time, Date
        value = type == 'string' ? value.to_s : l(value, format: :trst)
      when String, Integer, Float, BSON::ObjectId
        value = type == 'enum' ? mat(model,"#{attribute}_#{value}") : value
      when TrueClass, FalseClass
        value = t(value)
      else
        value = value.send order rescue value = ''
      end
      value
    end
    # @todo
    def guess_name(model,attribute,options)
      order,nested,index = options[:guess].try(:values_at,:order,:nested, :index)
      name  = "[#{model.class.name.underscore}]"
      if nested
        relation = model.relations[nested]
        name  = "[#{relation.class_name.underscore}]"
        name += ((model.metadata.macro.to_s.split('_').last rescue 'many') == 'one' ? "[#{relation.inverse_of.to_s}_attributes]" : "[#{relation.inverse_of.to_s}_attributes][#{index}]")
      end
      name += "[#{attribute}]"
      name += ((order.is_a? Integer) ? "[]" : "[#{order}]") if order
      name
    end
    # @todo
    def guess_icon(action)
      i = ['fa']
      case action
      when /query|filter/
        i.push 'fa-search'
      when /relations/
        i.push 'fa-arrows-h'
      when /create|add/
        i.push 'fa-plus-square-o'
      when /show|view/
        i.push 'fa-file-text-o'
      when /edit/
        i.push 'fa-edit'
      when /delete|remove/
        i.push 'fa-minus-square-o', 'red'
      when /save/
        i.push 'fa-floppy-o'
      when /print|pdf/
        i.push 'fa-print'
      when /cancel/
        i.push 'fa-ban'
      when /info|detail/
        i.push 'fa-info-circle', 'fa-lg', 'blue'
      when /warning/
        i.push 'fa-exclamation-triangle', 'fa-lg'
      when /error|error-red/
        i.push 'fa-bomb', 'fa-lg'
        i.push 'red' if action == 'error-red'
      when /loading/
        i.push 'fa-refresh', 'fa-spin', 'fa-lg'
      else
        i.push 'fa-bomb', 'fa-lg'
      end
      i.join(' ')
    end
    # @todo
    def label_for(model,attribute,options = {})
      order,type,label = options[:guess].try(:values_at,:order,:type,:label)
      field = attribute
      field = "#{attribute}_#{order}" if order
      field = "#{attribute}_id" if model.respond_to?("#{attribute}_id")
      field = "#{attribute}_label" if type == 'enum'
      field = label if label
      haml_tag  :span, mat(model,field)
    end
    # @todo
    def td_label_for(model,attribute,options = {})
      haml_tag :td,options.delete(:td) do
        label_for model,attribute,options
      end
    end
    # @todo
    def value_for(model,attribute,options = {})
      tag_attributes = options[:tag] || {}
      tag_attributes[:class] = attribute =~ /^id$|_at/ ? "ui-state-highlight #{tag_attributes[:class]}" : "ui-state-default #{tag_attributes[:class]}"
      tag_attributes[:class] = tag_attributes[:class].gsub('ui-state-default strip', '').strip
      precision = tag_attributes.delete(:precision) || 2
      value = guess_value model,attribute,options
      value = '-' if value.blank?
      value = '' if value == 'strip'
      value = "%.#{precision}f" % value if value.is_a?(Float)
      haml_tag  :span, value,tag_attributes.delete_if{|k,v| v.blank?}
    end
    # @todo
    def td_value_for(model,attribute,options = {})
      haml_tag :td,options.delete(:td) do
        value_for model,attribute,options
      end
    end
    # @todo
    def input_for(model,attribute,options = {})
      tag_attributes = options[:tag] || {}
      tag_attributes[:type] ||= 'text'
      tag_attributes[:value]||= guess_value model,attribute,options
      tag_attributes[:name] ||= guess_name  model,attribute,options
      tag_attributes[:class]  = tag_attributes[:type] == 'hidden' ? "#{tag_attributes[:class]}" : "ui-state-default #{tag_attributes[:class]}"
      tag_attributes[:class]  = tag_attributes[:class].gsub('ui-state-default strip', '').strip
      haml_tag :input,tag_attributes.delete_if{|k,v| v.blank? || v == 'strip'}
    end
    # @todo
    def td_input_for(model,attribute,options = {})
      haml_tag :td,options.delete(:td) do
        input_for model,attribute,options
      end
    end
    # @todo
    def select_for(model,attribute,options = {})
      id,name,type,style,select_options = options.values_at(:id,:name,:type,:style,:select_options)
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
      haml_tag :td,options.delete(:td) do
        select_for model,attribute,options
      end
    end
    # @todo
    def error_for(model,attribute,options = {})
      order,type = options.values_at(:order,:enum)
      value = "&nbsp;"
      messages = model.send(:errors).messages[attribute.to_sym]
      messages = model.send(:errors).messages["#{attribute}.#{order}".to_sym] if order
      if messages
        value = model.send(:errors).messages[attribute.to_sym]
        value = model.send(:errors).messages["#{attribute}.#{order}".to_sym] if order
        value = value.join(",\n")
      end
      haml_tag :span, value, class: 'error'
    end
    # @todo
    def td_error_for(model,attribute,options = {})
      haml_tag :td,options.delete(:td) do
        error_for model,attribute,options
      end
    end
    # @todo
    def tr_show_for(model,attribute,options = {})
      haml_tag :tr,options.delete(:tr) do
        td_label_for model,attribute,options
        td_value_for model,attribute,options
      end
    end
    # @todo
    def tr_input_for(model,attribute,options = {})
      haml_tag :tr,options.delete(:tr) do
        td_label_for   model,attribute,options
        td_input_for   model,attribute,options
        td_error_for   model,attribute,options
      end
    end
    # @todo
    def tr_select_for(model,attribute,options = {})
      haml_tag :tr,options.delete(:tr) do
        td_label_for   model,attribute,options
        td_select_for  model,attribute,options
        td_error_for   model,attribute,options
      end
    end
    # @todo
    def tr_header_for(labels,options = {})
      haml_tag :tr,options.delete(:tr) do
        labels.each do |label|
          haml_tag :td,options.delete(:td) do
            haml_tag :span,label,options.delete(:tag)
          end
        end
      end
    end
    # @todo
    def button(action,options = {})
      data  = {action: action, icon: guess_icon(action)}
      extra = options.delete(action.to_sym)
      text  = extra.delete(:text) if extra
      text ||= t("button.#{action}")
      data.merge! extra if extra
      haml_tag :button, type: 'button', data: data do
        haml_concat text
      end
    end
    # @todo
    def td_buttonset(buttons = [], options = {})
      td_attributes = options.delete(:td) || {}
      td_attributes[:class] ? td_attributes[:class] += ' buttonset' : td_attributes[:class] = 'buttonset'
      haml_tag :td, td_attributes do
        buttons.each{|b| button(b, options)}
      end
    end
    # @todo
    def tr_buttonset(buttons = [], options = {})
      haml_tag :tr,options.delete(:tr) do
        td_buttonset buttons, options
      end
    end
    # @todo
    def xhr_hidden_data(data = {})
      data[:model_name] = data[:model_name] || model_name
      data[:oid]        = data[:oid] || (@object.id rescue 'null')
      haml_tag :article, id: 'hidden_data', data: data
    end
    # @todo
    def xhr_info(type = 'info',text = 'Not defined')
      haml_tag :article, id: 'xhr_info', class: type do
        haml_tag :i, class: guess_icon(type)
        haml_concat text
      end
    end
    # @todo
    def td_detail_for(type = 'detail',text = 'Not defined', icon = nil)
      haml_tag :td do
        haml_tag :detail,class: type do
          haml_tag :i, class: icon.nil? ? guess_icon(type.split(' ').first) : guess_icon(icon)
          haml_concat text
        end
      end
    end
    # @todo
    def page_content(id,help = false)
      if help
        @task= Trst::Task.find(id)
        path = File.join(@task.goal.split('.')[0].underscore,'help')
        file = File.join(Trst.views,'system',"#{path}.haml")
        tmpl = File.exists?(file) ? path.to_sym : @task.help
      else
        page = Trst::Book.page(id) rescue Trst::Book.chapter(id)
        path = File.join('pages',I18n.locale.to_s,page.slug)
        file = false
        ['public', 'system'].each do |controller|
          f = File.join(Trst.views,controller,"#{path}.md")
          file = File.exists?(f) ? f : false unless file
        end
        tmpl = file != false ? File.read(file) : page.content
      end
      tmpl
    end
    # @todo
    def haml_path(action,_path = nil,related = nil)
      path = File.join(_path,action)
      ext  = action == 'pdf' ? 'rb' : 'haml'
      file = File.join(Trst.views,'system',"#{path}.#{ext}")
      haml_path = check_haml_path(file,path,ext)
      haml_path += '_related' if related
      haml_path = @task.haml_path if @task.haml_path != 'default'
      haml_path.to_sym
    end
    # @todo
    def check_haml_path(f,p,e)
      path = File.exists?(f) ? p : check_module(p)
      file = File.join(Trst.views,'system',"#{path}.#{e}")
      unless File.exists?(file)
        path = check_module(path,true)
      end
      path
    end
    # @todo
    def check_module(s,main = false)
      a = s.split('/')
      main ? a[0] = 'trst' : a = [a[0],a[-1]]
      a.join('/')
    end
 end # Helper
end # Trst
