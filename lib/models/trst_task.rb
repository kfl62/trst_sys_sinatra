# encoding: utf-8
=begin
#Task model
Defined fields and default values:
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
  include Mongoid::Timestamps

  field           :haml_path,       :type => String,      :default => "default"
  field           :page_ids,        :type => Array,       :default => []
  field           :user_ids,        :type => Array,       :default => []
  field           :target
  field           :name,            :localize => true
  field           :title,           :localize => true
  field           :help,            :localize => true

  before_update :sync_pages

  class << self
    # @todo Document this method
    def task_related_to
      all.asc(:name).collect{|task| [task.id.to_s, task.name]}
    end
    # @todo
    def task_id_by_target(t)
      where(:target => /#{t}/).first.id.to_s rescue nil
    end
  end
  # @todo Document this method
  def is_pdf?
    target.include?("TrstPdf.find_by_task_id")
  end
  # @todo Document this method
  def is_query?
    target.include?(".query")
  end
  def is_repair?
    target.include?(".repair")
  end
  # @todo Document this method
  def pages
    page_ids.collect{|id| TrstBook.page(id)}
  end
  # @todo Document this method
  def pages_name
     page_ids.collect{|id| "#{TrstBook.page(id).chapter.name}><b>#{TrstBook.page(id).name}</b><"}
  end
  # @todo Document this method
  def users
    user_ids
  end
  # @todo Document this method
  def users_name
    user_ids.collect{|id| TrstUser.find(id).login_name}
  end
  # @todo Document this method
  def table_data
    [{:css => "normal",:name => "haml_path",:label => I18n.t("trst_task.haml_path"),:value => haml_path},
     {:css => "normal",:name => "target",:label => I18n.t("trst_task.target"),:value => target},
     {:css => "relations",:name => "page_ids",:label => I18n.t("trst_task.page_ids"),:value => [pages_name,page_ids]},
     {:css => "relations",:name => "user_ids",:label => I18n.t("trst_task.user_ids"),:value => [users_name,users]},
     {:css => "localized",:name => "name",:label => I18n.t("trst_task.name"),:value => name_translations},
     {:css => "localized",:name => "title",:label => I18n.t("trst_task.title"),:value => title_translations},
     {:css => "localized",:name => "help",:label => I18n.t("trst_task.help"),:value => help_translations},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_task.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_task.updated_at"),:value => updated_at}]
  end

  protected
  def sync_pages
    pgch = self.page_ids_change
    if pgch
      if pgch.first.empty?
        pgch.last.each do |id|
          b = TrstBook.page(id)
          b.task_ids.push(self.id) unless b.task_ids.include?(self.id)
          b.save
        end
      else
        pgch.first.each do |id|
          b = TrstBook.page(id)
          if pgch.last.include?(id)
            b.task_ids.push(self.id) unless b.task_ids.include?(self.id)
          else
            b.task_ids.delete(self.id)
          end
          b.save
        end
      end
    end
  end
end
