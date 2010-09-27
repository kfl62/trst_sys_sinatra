# encoding: utf-8
=begin
#Task model
Defined fields an default values:
    field           :haml_path,   :type => String,  :default => "default"
    field           :page_ids,    :type => Array,   :default => []
    field           :user_ids,    :type => Array,   :default => []
    field           :target
    localized_field :name
    localized_field :title
    localized_field :help
Validations:
    TODO no validations defined
Associations:
    none
=end
class TrstTask
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::Timestamps

  field           :haml_path,       :type => String,      :default => "default"
  field           :page_ids,        :type => Array,       :default => []
  field           :user_ids,        :type => Array,       :default => []
  field           :target
  localized_field :name
  localized_field :title
  localized_field :help

  class << self
    #TODO missing docs
    def task_related_to
      all.collect{|task| [task.id.to_s, task.name]}
    end

  end
  #TODO missing docs
  def pages
    page_ids
  end
  #TODO missing docs
  def pages_name
     page_ids.collect{|id| "#{TrstBook.page(id).chapter.name}><b>#{TrstBook.page(id).name}</b><"}
  end
  #TODO missing docs
  def users
    user_ids
  end
  #TODO missing docs
  def users_name
    user_ids.collect{|id| TrstUser.find(id).login_name}
  end
  #TODO missing docs
  def table_data
    [{:css => "normal",:name => "haml_path",:label => I18n.t("trst_task.haml_path"),:value => haml_path},
     {:css => "normal",:name => "target",:label => I18n.t("trst_task.target"),:value => target},
     {:css => "relations",:name => "page_ids",:label => I18n.t("trst_task.page_ids"),:value => [pages_name,pages]},
     {:css => "relations",:name => "user_ids",:label => I18n.t("trst_task.user_ids"),:value => [users_name,users]},
     {:css => "localized",:name => "name",:label => I18n.t("trst_task.name"),:value => name_translations},
     {:css => "localized",:name => "title",:label => I18n.t("trst_task.title"),:value => title_translations},
     {:css => "localized",:name => "help",:label => I18n.t("trst_task.help"),:value => help_translations},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_task.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_task.updated_at"),:value => updated_at}]
  end
end
