desc "Initialize bundle"
task :init do
  `bundle install --path .bundle --binstubs .bundle/bin`
end
desc "Irb with DB environment loaded"
task :console do
  require './config/boot'
  require "irb"
  ARGV.clear
  IRB.start
end
namespace :db do
  desc "Seed data for Trst"
  task :seed do
    require './config/boot'
    Trst::Book.destroy_all
    %w{ro en hu}.each do |lang|
      I18n.locale = lang.to_sym
      books = YAML.load_file File.join(Trst.root,'tmp','seed',"books.yml")
      chapters = YAML.load_file File.join(Trst.root,'tmp','seed',"chapters.yml")
      pages = YAML.load_file File.join(Trst.root,'tmp','seed',"pages.yml")
      books[lang].each_pair do |slug,attributes|
        book = Trst::Book.find_or_create_by(slug: slug)
        book.update_attributes(attributes)
        chapters[lang][book.slug].each_pair do |slug,attributes|
          chapter = book.chapters.find_or_create_by(slug: slug)
          chapter.update_attributes(attributes)
          pages[lang][book.slug][chapter.slug].each_pair do |slug,attributes|
            chapter.pages.find_or_create_by(slug: slug).update_attributes(attributes)
          end if pages[lang][book.slug] && pages[lang][book.slug][chapter.slug]
        end
      end
    end
  end
end
