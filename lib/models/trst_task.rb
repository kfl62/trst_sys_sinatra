# encoding: utf-8
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

  def pages
    page_ids
  end

  def page_add(id)
    pages.push(id) unless pages.include?(id)
    update_attributes(:page_ids => pages)
  end

  def page_delete(id)
    pages.delete(id)
    update_attributes(:page_ids => pages)
  end

  def pages_name
    names = []
    page_ids.each do |id|
      page = TrstBook.page(id)
      names << "#{page.chapter.name}><b>#{page.name}</b><"
    end
    names
  end

  def users
    user_ids
  end
  
  def users_name
    names = []
    user_ids.each do |id|
      user = TrstUser.find(id)
      names << user.login_name
    end
    names
  end

  def user_add(id)
    users.push(id) unless users.include?(id)
    update_attributes(:user_ids => users)
  end

  def user_delete(id)
    users.delete(id)
    update_attributes(:user_ids => users)
  end

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
