# encoding: utf-8
module Trst
  #Book model
  # Defined fields and default values:
  #    localized_field :name
  #    localized_field :content
  #Validations:
  #    validates_presence_of :name
  #Associations:
  #    embeds_many :chapters, :class_name  => "Trst::Chapter"
  class Book
    include Mongoid::Document
    include Mongoid::Timestamps

    field :slug,    type: String
    field :name,    type: String, localize: true
    field :content, type: String, localize: true

    validates_presence_of :slug

    embeds_many :chapters, class_name:  'Trst::Chapter'

    class << self
      # @todo Document this method
      def page(id)
        book = where(:'chapters.pages._id'  => BSON::ObjectId.from_string("#{id}")).first
        chapter = book.chapters.where(:'pages._id' => BSON::ObjectId.from_string("#{id}")).first
        page = chapter.pages.find(id)
      end
      # @todo Document this method
      def chapter(id)
        book = where('chapters._id'  => BSON::ObjectId.from_string("#{id}")).first
        chapter = book.chapters.find(id)
      end
      # @todo Document this method
      def public_pages
        book = where(name: "trst_pub").first
        book.chapters.each_with_object([]) do |chapter,a|
          chapter.pages.each{|page| a << [page.id.to_s, "#{page.chapter.name}>#{page.name}<"]}
        end
      end
      # @todo Document this method
      def system_pages
        book = where(name: "trst_sys").first
        book.chapters.each_with_object([]) do |chapter,a|
          chapter.pages.each{|page| a << [page.id.to_s, "#{page.chapter.name}>#{page.name}<"]}
        end
      end
      alias page_related_to system_pages
    end # Class methods
  end # Book

  # #Chapter model
  # Defined fields and default values:
  #     field :order ,     type: Integer
  #     field :slug,       type: String
  #     localized_field :name
  #     localized_field :title
  #     localized_field :content
  # Validations:
  #     TODO no validations defined
  # Associations:
  #     embedded_in :book,  class_name: 'Trst::Book', inverse_of: :chapters
  #     embeds_many :pages, class_name: 'Trst::Page'
  class Chapter
    include Mongoid::Document
    include Mongoid::Timestamps

    field :slug,    type: String
    field :order,   type: Integer
    field :name,    type: String,   localize: true
    field :title,   type: String,   localize: true
    field :content, type: String,   localize: true

    validates_presence_of :slug

    embedded_in :book,  class_name: 'Trst::Book', inverse_of: :chapters
    embeds_many :pages, class_name: 'Trst::Page'

    # @todo Document this method
    def path
      slug == 'home' ? '/index.html' : "/#{slug.dasherize}/index.html"
    end
    # @todo
    def embedded_in
      chapter
    end
  end # Chapter

  # #Page model
  # Defined fields and default values:
  #     field :order,           type: Integer
  #     field :slug,            type: String
  #     field :access_lvl,      type: Integer,       default: 3
  #     field :access_grp,      type: Array,         default: ['public','admin']
  #     field :task_ids,        type: Array,         default: []
  #     localized_field :name
  #     localized_field :title
  #     localized_field :content
  # Validations:
  #     TODO no validations defined
  # Associations:
  #     embedded_in :chapter, inverse_of: :pages
  class Page
    include Mongoid::Document
    include Mongoid::Timestamps

    field :slug,            type: String
    field :order,           type: Integer
    field :access_lvl,      type: Integer,       default: 3
    field :access_grp,      type: Array,         default: ['public']
    field :name,            localize: true
    field :title,           localize: true
    field :content,         localize: true

    validates_presence_of :slug

    embedded_in             :chapter, class_name: 'Trst::Chapter', inverse_of: :pages
    has_and_belongs_to_many :tasks,   class_name: 'Trst::Task',    inverse_of: nil

    class << self
      # @todo
      def task_ids(id)
        Trst::Book.page(id).task_ids
      end
    end # Class methods

    # @todo Document this method
    def path
      retval = chapter.slug == 'home' ? '/' : "/#{chapter.slug.dasherize}/"
      retval += "trustsys-#{chapter.slug.dasherize}-#{slug.dasherize}.html"
    end
    # @todo
    def embedded_in
      chapter
    end
    # @todo Document this method
    def view_tasks
      task_ids.each_with_object([]){|id,a| t = tasks.find(id); a << [t.id, t.name]}
    end
  end # Page

end # Trst
