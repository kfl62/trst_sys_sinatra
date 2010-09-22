# encoding: utf-8
class TrstBook
  include Mongoid::Document
  include Mongoid::I18n
  include Mongoid::Timestamps

  localized_field :name
  localized_field :content

  embeds_many :chapters, :class_name  => "TrstBookChapter"

  validates_presence_of :name

  class << self

    def page(id)
      book = where('chapters.pages._id'  => BSON::ObjectId(id)).first
      chapter = nil
      book.chapters.each{ |c| chapter = c if c.pages.find(id)}
      page = chapter.pages.find(id)
    end

    def chapter(id)
      book = where('chapters._id'  => BSON::ObjectId(id)).first
      chapter = book.chapters.find(id)
    end

    def daily_tasks_page
      bk = where(:name => 'trst_sys').first
      ch = bk.chapters.where(:slug  => "my_page").first
      pg = ch.pages.where(:slug  => "tasks").first
    end

    def trst_pub_pages
      retval = []
      book = where(:name  => "trst_pub").first
      book.chapters.each do |chapter|
        chapter.pages.each{|page| retval << [page.id.to_s, "#{page.chapter.name}>#{page.name}<"]}
      end
      return retval
    end

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

  def table_data
    [{:css => "translated",:name => "name",:label => I18n.t("trst_book.name"),:value => name},
     {:css => "translated",:content => "content",:label => I18n.t("trst_book.content"),:value => content}]
  end

end
