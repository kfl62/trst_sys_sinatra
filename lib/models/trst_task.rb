# encoding: utf-8
class TrstTask
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::Timestamps

  field           :haml_path
  field           :page_ids,        :type => Array,       :default => []
  field           :user_ids,        :type => Array,       :default => []
  field           :verbs,           :type => Array,       :default => []
  localized_field :name
  localized_field :help

  def composite
    verbs.empty? ? false : verbs
  end

  def pages
    page_ids
  end

  def users
    user_ids
  end
end
