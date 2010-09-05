# encoding: utf-8
class TrstBookChapter
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::Timestamps

  field :order,           :type  => Integer
  field :slug
  localized_field :name
  localized_field :title
  localized_field :content

  def path
    slug == "home" ? retval = "/index.html" : retval = "/#{slug}/index.html"
    retval
  end

  embedded_in :book, :inverse_of => :chapters
  embeds_many :pages, :class_name => "TrstBookPage"
end
