# encoding: utf-8
class TrstTask
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::Timestamps

  field           :haml_path
  field           :page_ids,        :type => Array,       :default => []
  field           :user_ids,        :type => Array,       :default => []
  field           :model
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

  def users
    user_ids
  end
  
  def user_add(id)
    users.push(id) unless users.include?(id)
    update_attributes(:user_ids => users)
  end

  def user_delete(id)
    users.delete(id)
    update_attributes(:user_ids => users)
  end

end
