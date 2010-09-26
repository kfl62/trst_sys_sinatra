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

  embedded_in :book, :inverse_of => :chapters
  embeds_many :pages, :class_name => "TrstBookPage"

  def path
    slug == "home" ? retval = "/index.html" : retval = "/#{slug}/index.html"
    retval
  end

  def table_data
    [{:css => "integer",:name => "order",:label => I18n.t("trst_book_chapter.order"),:value => order},
     {:css => "normal",:name => "slug",:label => I18n.t("trst_book_chapter.slug"),:value => slug},
     {:css => "localized",:name => "name",:label => I18n.t("trst_book_chapter.name"),:value => name_translations},
     {:css => "localized",:name => "title",:label => I18n.t("trst_book_chapter.title"),:value => title_translations},
     {:css => "localized",:name => "content",:label => I18n.t("trst_book_chapter.content"),:value => content_translations},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_book_chapter.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_book_chapter.updated_at"),:value => updated_at}]
  end

end
