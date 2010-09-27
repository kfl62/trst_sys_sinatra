# encoding: utf-8
=begin
#Book model
Defined fields an default values:
    localized_field :name
    localized_field :content
Validations:
    validates_presence_of :name
Associations:
    embeds_many :chapters, :class_name  => "TrstBookChapter"
=end
class TrstBook
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::Timestamps

  localized_field :name
  localized_field :content

  validates_presence_of :name

  embeds_many :chapters, :class_name  => "TrstBookChapter"

  class << self
    #TODO missing docs
    def page(id)
      book = where('chapters.pages._id'  => BSON::ObjectId("#{id}")).first
      chapter = nil
      book.chapters.each{ |c| chapter = c if c.pages.find(id)}
      page = chapter.pages.find(id)
    end
    #TODO missing docs
    def chapter(id)
      book = where('chapters._id'  => BSON::ObjectId("#{id}")).first
      chapter = book.chapters.find(id)
    end
    #TODO missing docs
    def daily_tasks_page
      bk = where(:name => 'trst_sys').first
      ch = bk.chapters.where(:slug  => "my_page").first
      pg = ch.pages.where(:slug  => "tasks").first
    end
    #TODO missing docs
    def trst_pub_pages
      retval = []
      book = where(:name  => "trst_pub").first
      book.chapters.each do |chapter|
        chapter.pages.each{|page| retval << [page.id.to_s, "#{page.chapter.name}>#{page.name}<"]}
      end
      return retval
    end
    #TODO missing docs
    def trst_sys_pages
      retval = []
      book = where(:name  => "trst_sys").first
      book.chapters.each do |chapter|
        chapter.pages.each{|page| retval << [page.id.to_s, "#{page.chapter.name}>#{page.name}<"]}
      end
      return retval
    end

    alias page_related_to trst_sys_pages

  end
  #TODO missing docs
  def table_data
    [{:css => "localized",:name => "name",:label => I18n.t("trst_book.name"),:value => name_translations},
     {:css => "localized",:name => "content",:label => I18n.t("trst_book.content"),:value => content_translations},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_book.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_book.updated_at"),:value => updated_at}]
  end

end
