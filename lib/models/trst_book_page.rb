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
  
  def task_add(id)
    tasks.push(id) unless tasks.include?(id)
    update_attributes(:task_ids => tasks)
  end

  def task_delete(id)
    tasks.delete(id)
    update_attributes(:task_ids => tasks)
  end

  embedded_in :chapter, :inverse_of => :pages
end
