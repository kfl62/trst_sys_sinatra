# encoding: utf-8
=begin
#Reports model
Defined fields and default values:
    field           :task_ids,        :type => Array,       :default => []
    field           :file_name,       :type => String,      :default => "report"
    field           :default_values,  :type => Hash,        :default => {}
    field           :last,            :type => Hash,        :default => {}
    localized_field :name
    localized_field :title
    localized_field :help
Validations:
    TODO no validations defined
Associations:
    none
=end
class TrstPdf
  include Mongoid::Document
  #include Mongoid::I18n
  include Mongoid::Timestamps

  field           :task_ids,        :type => Array,       :default => []
  field           :file_name,       :type => String,      :default => "ReportName"
  field           :pdf_template,    :type => String,      :default => "report"
  field           :default_values,  :type => Hash,        :default => {}
  field           :last_values,     :type => Hash,        :default => {}
  field           :name,            :localize => true
  field           :title,           :localize => true
  field           :help,            :localize => true

  class << self
    # @todo Document this method
    def find_by_task_id(id)
      all.in(:task_ids => [id]).first
    end

  end
  # @todo Document this method
  def tasks
    task_ids
  end
  # @todo Document this method
  def tasks_name
    task_ids.collect{|id| TrstTask.find(id).name}
  end
  # @todo Document this method
  def table_data
    [{:css => "normal",:name => "file_name",:label => I18n.t("trst_pdf.file_name"),:value => file_name},
     {:css => "normal",:name => "pdf_template",:label => I18n.t("trst_pdf.pdf_template"),:value => pdf_template},
     {:css => "relations",:name => "task_ids",:label => I18n.t("trst_pdf.task_ids"),:value => [tasks_name,tasks]},
     {:css => "localized",:name => "name",:label => I18n.t("trst_pdf.name"),:value => name_translations},
     {:css => "localized",:name => "title",:label => I18n.t("trst_pdf.title"),:value => title_translations},
     {:css => "localized",:name => "help",:label => I18n.t("trst_pdf.help"),:value => help_translations},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_pdf.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_pdf.updated_at"),:value => updated_at}]
  end
  # @todo Document this method
  def table_params
    unless last_values.empty?
      retval = []
      last_values.each_pair do |key,value|
        retval << {:css => "normal",:name => "[trst_pdf][last_values][#{key}]",:label => I18n.t("trst_pdf.#{pdf_template}.#{key}"),:value => value}
      end
    else
      retval = I18n.t("trst_pdf.no_params")
    end
    return retval
  end
end
