# encoding: utf-8
class TrstBookPage
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::Timestamps

  field :order,           :type => Integer
  field :slug
  field :access_lvl,      :type => Integer,           :default => 3
  field :access_grp,      :type => Array,             :default => ["public","admin"]
  field :task_ids,        :type => Array,             :default => []
  localized_field :name
  localized_field :title
  localized_field :content

  def path
    chapter.slug == "home" ? retval = "/" : retval = "/#{chapter.slug}/"
    retval += "TrustSys-#{chapter.slug.camelize}-#{slug}.html"
    retval
  end

  def tasks
    task_ids
  end

  def tasks_name
    task_ids.collect{|id| TrstTask.find(id).name}
  end

  def table_data
    [{:css => "integer",:name => "order",:label => I18n.t("trst_book_page.order"),:value => order},
     {:css => "normal",:name => "slug",:label => I18n.t("trst_book_page.slug"),:value => slug},
     {:css => "integer",:name => "access_lvl",:label => I18n.t("trst_book_page.access_lvl"),:value => access_lvl},
     {:css => "array",:name => "access_grp",:label => I18n.t("trst_book_page.access_grp"),:value => access_grp},
     {:css => "relations",:name => "task_ids",:label => I18n.t("trst_book_page.task_ids"),:value => [tasks_name,tasks]},
     {:css => "localized",:name => "name",:label => I18n.t("trst_book_page.name"),:value => name_translations},
     {:css => "localized",:name => "title",:label => I18n.t("trst_book_page.title"),:value => title_translations},
     {:css => "localized",:name => "content",:label => I18n.t("trst_book_page.content"),:value => content_translations},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_book_page.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_book_page.updated_at"),:value => updated_at}]
  end

  embedded_in :chapter, :inverse_of => :pages
end
