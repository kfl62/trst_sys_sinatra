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
      book = where('chapters.pages._id'  => BSON::ObjectID("#{id}")).first
      chapter = nil
      book.chapters.each{ |c| chapter = c if c.pages.find(id)}
      page = chapter.pages.find(id)
    end

    def chapter(id)
      book = where('chapters._id'  => BSON::ObjectID("#{id}")).first
      chapter = book.chapters.find(id)
    end
    
    def daily_tasks_page
      bk = where(:name => 'trst_sys').first
      ch = bk.chapters.where(:slug  => "my_page").first
      pg = ch.pages.where(:slug  => "tasks").first
    end

    def page_related_to
      retval = []
      book = where(:name  => "trst_sys").first
      book.chapters.each do |chapter|
        chapter.pages.each{|page| retval << [page.id.to_s, "#{page.chapter.name}>#{page.name}<"]}
      end
      return retval
    end

  end

end
